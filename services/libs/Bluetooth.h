/* Bluetooth.h generated by valac 0.56.16, the Vala compiler, do not modify */

#ifndef ___HOME_EM_DESKTOP_CODE_DOCKS_SERVICES_LIBS_BLUETOOTH_H__
#define ___HOME_EM_DESKTOP_CODE_DOCKS_SERVICES_LIBS_BLUETOOTH_H__

#include <glib-object.h>
#include <glib.h>

G_BEGIN_DECLS

#if !defined(VALA_EXTERN)
#if defined(_MSC_VER)
#define VALA_EXTERN __declspec(dllexport) extern
#elif __GNUC__ >= 4
#define VALA_EXTERN __attribute__((visibility("default"))) extern
#else
#define VALA_EXTERN extern
#endif
#endif

#define TYPE_BLUETOOTH (bluetooth_get_type ())
#define BLUETOOTH(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_BLUETOOTH, Bluetooth))
#define BLUETOOTH_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_BLUETOOTH, BluetoothClass))
#define IS_BLUETOOTH(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_BLUETOOTH))
#define IS_BLUETOOTH_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_BLUETOOTH))
#define BLUETOOTH_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_BLUETOOTH, BluetoothClass))

typedef struct _Bluetooth Bluetooth;
typedef struct _BluetoothClass BluetoothClass;
typedef struct _BluetoothPrivate BluetoothPrivate;

struct _Bluetooth {
	GObject parent_instance;
	BluetoothPrivate * priv;
};

struct _BluetoothClass {
	GObjectClass parent_class;
};

VALA_EXTERN GType bluetooth_get_type (void) G_GNUC_CONST ;
G_DEFINE_AUTOPTR_CLEANUP_FUNC (Bluetooth, g_object_unref)
VALA_EXTERN Bluetooth* bluetooth_new (void);
VALA_EXTERN Bluetooth* bluetooth_construct (GType object_type);

G_END_DECLS

#endif
