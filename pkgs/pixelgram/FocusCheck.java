// Run as a Java agent with -Dpixelgram.demo=true under an isolated HOME and Xvfb.
// Never uses a real Telegram account or sends a message.
import com.pixelgram.desktop.telegram.Telegram;
import com.pixelgram.desktop.telegram.AuthState;
import com.pixelgram.desktop.core.AppLock;
import com.pixelgram.desktop.ui.main.Links;
import java.awt.Frame;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.lang.instrument.Instrumentation;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

public class FocusCheck {
    private static <T> T edt(Callable<T> action) throws Exception {
        var task = new FutureTask<T>(action);
        SwingUtilities.invokeAndWait(task);
        return task.get();
    }

    private static void await(Callable<Boolean> condition, String message) throws Exception {
        long deadline = System.nanoTime() + 30_000_000_000L;
        while (System.nanoTime() < deadline) {
            if (edt(condition)) return;
            Thread.sleep(100);
        }
        throw new AssertionError(message);
    }

    private static void type(Robot robot, int key) throws Exception {
        if (robot != null) {
            robot.keyPress(key);
            robot.keyRelease(key);
            return;
        }
        // Wayland forbids global Robot injection; send the key to AWT's actual focus owner.
        edt(() -> {
            var owner = java.awt.KeyboardFocusManager.getCurrentKeyboardFocusManager().getFocusOwner();
            if (owner == null) throw new AssertionError("Missing AWT focus owner");
            long now = System.currentTimeMillis();
            char character = Character.toLowerCase((char) key);
            owner.dispatchEvent(new KeyEvent(owner, KeyEvent.KEY_PRESSED, now, 0, key, character));
            owner.dispatchEvent(new KeyEvent(owner, KeyEvent.KEY_TYPED, now, 0, KeyEvent.VK_UNDEFINED, character));
            owner.dispatchEvent(new KeyEvent(owner, KeyEvent.KEY_RELEASED, now, 0, key, character));
            return null;
        });
    }

    public static void premain(String args, Instrumentation instrumentation) {
        String home = System.getProperty("user.home");
        if (!Boolean.getBoolean("pixelgram.demo")
            || !Files.isRegularFile(Path.of(home, ".pixelgram-focus-test"))
            || !home.equals(System.getenv("HOME"))
            || !(home + "/data").equals(System.getenv("XDG_DATA_HOME"))
            || !(home + "/config").equals(System.getenv("XDG_CONFIG_HOME"))) {
            throw new IllegalStateException("FocusCheck requires demo mode and an isolated test home");
        }
        new Thread(() -> {
            try {
                check();
                System.out.println("PASS: typing resumes after window focus without clicking the composer");
                if (!Boolean.getBoolean("pixelgram.focus.keepAlive")) System.exit(0);
            } catch (Throwable error) {
                error.printStackTrace();
                System.exit(1);
            }
        }, "focus-check").start();
    }

    private static void check() throws Exception {
        await(() -> Links.INSTANCE.getActive() != null
            && Links.INSTANCE.getNavigate() != null, "Demo account did not load");
        Telegram telegram = edt(() -> {
            // Demo populates chats but does not authenticate its fake account.
            var active = Links.INSTANCE.getActive();
            for (var field : active.getClass().getDeclaredFields()) {
                if (field.getType() == Telegram.class) {
                    field.setAccessible(true);
                    return (Telegram) field.get(active);
                }
            }
            throw new AssertionError("Missing demo account");
        });
        await(() -> telegram.getChats().containsKey(101L)
            && telegram.getAuthState() == AuthState.WaitPhone.INSTANCE, "Demo data did not load");
        edt(() -> {
            var setAuth = Telegram.class.getDeclaredMethod(
                "setAuthState$com_pixelgram_desktop_pixelgram", AuthState.class);
            setAuth.invoke(telegram, AuthState.Ready.INSTANCE);
            return null;
        });
        await(() -> Frame.getFrames().length > 0, "Missing pixelGram frame");
        Frame window = edt(() -> {
            for (Frame frame : Frame.getFrames()) {
                if (frame.isShowing() && frame.getTitle().contains("pixelGram")) return frame;
            }
            throw new AssertionError("Missing pixelGram window");
        });
        edt(() -> { Links.INSTANCE.getNavigate().invoke(telegram, 101L); return null; });
        Thread.sleep(1500);
        boolean wayland = java.awt.Toolkit.getDefaultToolkit().getClass().getName().equals("sun.awt.wl.WLToolkit");
        Robot robot = wayland ? null : new Robot();
        if (robot != null) robot.setAutoDelay(60);
        JFrame other = edt(() -> {
            var frame = new JFrame("Other application");
            frame.setSize(200, 100);
            frame.setVisible(true);
            return frame;
        });
        for (int key : new int[] { KeyEvent.VK_A, KeyEvent.VK_B, KeyEvent.VK_C }) {
            edt(() -> { other.toFront(); other.requestFocus(); return null; });
            await(other::isFocused, "Could not focus the other window");
            String before = edt(() -> telegram.getChats().get(101L).getDraft());
            type(robot, KeyEvent.VK_X);
            Thread.sleep(250);
            if (!before.equals(edt(() -> telegram.getChats().get(101L).getDraft()))) {
                throw new AssertionError("Unfocused composer received input");
            }
            edt(() -> { window.toFront(); window.requestFocus(); return null; });
            await(window::isFocused, "Could not restore pixelGram window focus");
            Thread.sleep(250);
            type(robot, key);
            String expected = before + Character.toLowerCase((char) key);
            await(() -> expected.equals(telegram.getChats().get(101L).getDraft()),
                "Composer did not receive the first key after focus");
        }
        String draft = edt(() -> telegram.getChats().get(101L).getDraft());
        edt(() -> {
            AppLock.INSTANCE.setPasscode("1234");
            AppLock.INSTANCE.lock();
            return null;
        });
        Thread.sleep(500);
        edt(() -> { other.toFront(); other.requestFocus(); return null; });
        await(other::isFocused, "Could not focus the other window");
        edt(() -> { window.toFront(); window.requestFocus(); return null; });
        await(window::isFocused, "Could not restore the locked window");
        Thread.sleep(250);
        type(robot, KeyEvent.VK_1);
        Thread.sleep(500);
        if (!draft.equals(edt(() -> telegram.getChats().get(101L).getDraft()))) {
            throw new AssertionError("Locked composer received passcode input");
        }
        edt(() -> { other.dispose(); return null; });
    }
}
