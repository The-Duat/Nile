import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk as gtk

settings = gtk.Settings.get_default()

with open("/var/mizOS/config/gtk/settings/gtk-theme", "r") as f:
	gtk_theme = f.read()

with open("/var/mizOS/config/gtk/settings/icon-theme", "r") as f:
	icon_theme = f.read()

with open("/var/mizOS/config/gtk/settings/cursor-theme", "r") as f:
	cursor_theme = f.read()

settings.set_property("gtk-theme-name", gtk_theme)
settings.set_property("gtk-icon-theme-name", icon_theme)
settings.set_property("gtk-cursor-theme-name", cursor_theme)

gtk.StyleContext().invalidate()
settings.apply()