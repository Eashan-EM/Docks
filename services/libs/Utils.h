/* Utils.h generated by valac 0.56.16, the Vala compiler, do not modify */

#ifndef ___HOME_EM_DESKTOP_CODE_DOCKS_SERVICES_LIBS_UTILS_H__
#define ___HOME_EM_DESKTOP_CODE_DOCKS_SERVICES_LIBS_UTILS_H__

#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>
#include <glib.h>
#include <glib-object.h>

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

#define UTILS_TYPE_EXEC_THREADS (utils_exec_threads_get_type ())
#define UTILS_EXEC_THREADS(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), UTILS_TYPE_EXEC_THREADS, UtilsExec_Threads))
#define UTILS_EXEC_THREADS_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), UTILS_TYPE_EXEC_THREADS, UtilsExec_ThreadsClass))
#define UTILS_IS_EXEC_THREADS(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), UTILS_TYPE_EXEC_THREADS))
#define UTILS_IS_EXEC_THREADS_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), UTILS_TYPE_EXEC_THREADS))
#define UTILS_EXEC_THREADS_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), UTILS_TYPE_EXEC_THREADS, UtilsExec_ThreadsClass))

typedef struct _UtilsExec_Threads UtilsExec_Threads;
typedef struct _UtilsExec_ThreadsClass UtilsExec_ThreadsClass;
typedef struct _UtilsExec_ThreadsPrivate UtilsExec_ThreadsPrivate;

#define UTILS_TYPE_TIME_THREADS (utils_time_threads_get_type ())
#define UTILS_TIME_THREADS(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), UTILS_TYPE_TIME_THREADS, UtilsTime_Threads))
#define UTILS_TIME_THREADS_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), UTILS_TYPE_TIME_THREADS, UtilsTime_ThreadsClass))
#define UTILS_IS_TIME_THREADS(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), UTILS_TYPE_TIME_THREADS))
#define UTILS_IS_TIME_THREADS_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), UTILS_TYPE_TIME_THREADS))
#define UTILS_TIME_THREADS_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), UTILS_TYPE_TIME_THREADS, UtilsTime_ThreadsClass))

typedef struct _UtilsTime_Threads UtilsTime_Threads;
typedef struct _UtilsTime_ThreadsClass UtilsTime_ThreadsClass;
typedef struct _UtilsTime_ThreadsPrivate UtilsTime_ThreadsPrivate;

struct _UtilsExec_Threads {
	GObject parent_instance;
	UtilsExec_ThreadsPrivate * priv;
};

struct _UtilsExec_ThreadsClass {
	GObjectClass parent_class;
};

struct _UtilsTime_Threads {
	GObject parent_instance;
	UtilsTime_ThreadsPrivate * priv;
};

struct _UtilsTime_ThreadsClass {
	GObjectClass parent_class;
};

VALA_EXTERN void utils_add_class (GtkWidget* wid,
                      const gchar* class_name);
VALA_EXTERN void utils_remove_class (GtkWidget* wid,
                         const gchar* class_name);
VALA_EXTERN void utils_load_style (const gchar* file_name);
VALA_EXTERN gchar* utils_curr_dir (void);
VALA_EXTERN gchar* utils_exec (gchar** command,
                   gint command_length1);
VALA_EXTERN GType utils_exec_threads_get_type (void) G_GNUC_CONST ;
G_DEFINE_AUTOPTR_CLEANUP_FUNC (UtilsExec_Threads, g_object_unref)
VALA_EXTERN UtilsExec_Threads* utils_exec_threads_new (gchar** command,
                                           gint command_length1,
                                           const gchar* name);
VALA_EXTERN UtilsExec_Threads* utils_exec_threads_construct (GType object_type,
                                                 gchar** command,
                                                 gint command_length1,
                                                 const gchar* name);
VALA_EXTERN void utils_exec_threads_start (UtilsExec_Threads* self);
VALA_EXTERN GType utils_time_threads_get_type (void) G_GNUC_CONST ;
G_DEFINE_AUTOPTR_CLEANUP_FUNC (UtilsTime_Threads, g_object_unref)
VALA_EXTERN UtilsTime_Threads* utils_time_threads_new (gint time,
                                           gchar** command,
                                           gint command_length1,
                                           const gchar* name);
VALA_EXTERN UtilsTime_Threads* utils_time_threads_construct (GType object_type,
                                                 gint time,
                                                 gchar** command,
                                                 gint command_length1,
                                                 const gchar* name);
VALA_EXTERN void utils_time_threads_start (UtilsTime_Threads* self);

G_END_DECLS

#endif