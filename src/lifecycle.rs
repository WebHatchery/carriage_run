//! Window activity and input re-arming across focus transitions.

use macroquad::miniquad::EventHandler;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ActivityFrame {
    pub focused: bool,
    pub input_enabled: bool,
    pub focus_lost: bool,
}

#[derive(Debug, Clone, Copy)]
struct ActivityState {
    focused: bool,
    input_armed: bool,
}

impl ActivityState {
    fn new() -> Self {
        Self {
            focused: true,
            input_armed: true,
        }
    }

    fn observe(&mut self, focused: bool, controls_neutral: bool) -> ActivityFrame {
        let focus_lost = self.focused && !focused;
        if !focused {
            self.input_armed = false;
        } else if !self.focused {
            // A click or held direction may have restored focus. Wait until all
            // controls are released before gameplay can consume input again.
            self.input_armed = false;
        } else if controls_neutral {
            self.input_armed = true;
        }
        self.focused = focused;
        ActivityFrame {
            focused,
            input_enabled: focused && self.input_armed,
            focus_lost,
        }
    }
}

pub struct WindowActivity {
    subscriber: usize,
    event_focused: bool,
    state: ActivityState,
}

impl WindowActivity {
    pub fn new() -> Self {
        Self {
            subscriber: macroquad::input::utils::register_input_subscriber(),
            event_focused: true,
            state: ActivityState::new(),
        }
    }

    pub fn poll(&mut self, controls_neutral: bool) -> ActivityFrame {
        macroquad::input::utils::repeat_all_miniquad_input(self, self.subscriber);
        let focused = platform_window_focused(self.event_focused);
        self.state.observe(focused, controls_neutral)
    }
}

impl EventHandler for WindowActivity {
    fn update(&mut self) {}

    fn draw(&mut self) {}

    fn window_minimized_event(&mut self) {
        self.event_focused = false;
    }

    fn window_restored_event(&mut self) {
        self.event_focused = true;
    }
}

#[cfg(target_os = "windows")]
fn platform_window_focused(event_focused: bool) -> bool {
    use std::ffi::c_void;

    #[link(name = "user32")]
    unsafe extern "system" {
        fn GetActiveWindow() -> *mut c_void;
    }

    // SAFETY: GetActiveWindow has no parameters and returns either the active
    // window owned by this UI thread or null. The handle is never dereferenced.
    event_focused && unsafe { !GetActiveWindow().is_null() }
}

#[cfg(not(target_os = "windows"))]
fn platform_window_focused(event_focused: bool) -> bool {
    event_focused
}

#[cfg(test)]
mod tests;
