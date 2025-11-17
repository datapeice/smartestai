/* MIT License
 *
 * Copyright (c) 2025 Illia Datsiuk
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * SPDX-License-Identifier: MIT
 */

namespace Smartestai {
    [GtkTemplate (ui = "/com/datapeice/smartestai/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild] private unowned Gtk.Button generate_button;
        [GtkChild] private unowned Gtk.TextView text_view;

        private Gtk.Fixed fixed_container;
        private bool button_centered = false;

        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {

            find_fixed_container(get_content() as Gtk.Widget);

            if (fixed_container != null) {
                map.connect(() => {
                    if (!button_centered) {
                        GLib.Timeout.add(100, () => {
                            center_button();
                            button_centered = true;
                            return false;
                        });
                    }
                });

                var motion_controller = new Gtk.EventControllerMotion();
                motion_controller.motion.connect(on_button_motion);
                generate_button.add_controller(motion_controller);
            }
            var buffer = text_view.get_buffer();
            buffer.set_text("Type your query here...", -1);
        }

        private void find_fixed_container(Gtk.Widget widget) {
            if (widget is Gtk.Fixed) {
                fixed_container = widget as Gtk.Fixed;
                return;
            }

            for (var child = widget.get_first_child(); child != null; child = child.get_next_sibling()) {
                find_fixed_container(child);
                if (fixed_container != null) return;
            }
        }

        private void center_button() {
            int container_width = fixed_container.get_allocated_width();
            int container_height = fixed_container.get_allocated_height();
            int button_width = generate_button.get_allocated_width();
            int button_height = generate_button.get_allocated_height();

            int x = (container_width - button_width) / 2;
            int y = (container_height - button_height) / 2;

            fixed_container.move(generate_button, x, y);
        }

        private void on_button_motion(double x, double y) {
            var random = new GLib.Rand();
            int button_width = generate_button.get_allocated_width();
            int button_height = generate_button.get_allocated_height();
            int container_width = fixed_container.get_allocated_width();
            int container_height = fixed_container.get_allocated_height();

            int new_x = random.int_range(0, (container_width - button_width).clamp(1, int.MAX));
            int new_y = random.int_range(0, (container_height - button_height).clamp(1, int.MAX));

            fixed_container.move(generate_button, new_x, new_y);
        }
    }
}
