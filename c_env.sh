export CPATH=/usr/include/gtk-4.0:/usr/lib64/glib-2.0/include:/usr/include/cairo:/usr/include/pango-1.0:/usr/include/glib-2.0:/usr/include/harfbuzz:/usr/include/gdk-pixbuf-2.0:/usr/include/graphene-1.0:/usr/lib64/graphene-1.0/include
meson --prefix $PWD/install build
