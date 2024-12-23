/* Audio.h generated by valac 0.56.16, the Vala compiler, do not modify */

#ifndef ___HOME_EM_DESKTOP_CODE_DOCKS_SERVICES_LIBS_AUDIO_H__
#define ___HOME_EM_DESKTOP_CODE_DOCKS_SERVICES_LIBS_AUDIO_H__

#include <glib-object.h>
#include <glib.h>
#include <stdlib.h>
#include <string.h>
#include <pulse/pulseaudio.h>

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

#define TYPE_AUDIO (audio_get_type ())
#define AUDIO(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_AUDIO, Audio))
#define AUDIO_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_AUDIO, AudioClass))
#define IS_AUDIO(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_AUDIO))
#define IS_AUDIO_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_AUDIO))
#define AUDIO_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_AUDIO, AudioClass))

typedef struct _Audio Audio;
typedef struct _AudioClass AudioClass;
typedef struct _AudioPrivate AudioPrivate;

struct _Audio {
	GObject parent_instance;
	AudioPrivate * priv;
};

struct _AudioClass {
	GObjectClass parent_class;
};

VALA_EXTERN GType audio_get_type (void) G_GNUC_CONST ;
G_DEFINE_AUTOPTR_CLEANUP_FUNC (Audio, g_object_unref)
VALA_EXTERN void audio_start (Audio* self);
VALA_EXTERN gchar* audio_set_sink_default_volume (Audio* self,
                                      gint volume);
VALA_EXTERN gchar* audio_set_sink_default_volume_inc (Audio* self,
                                          gint volume);
VALA_EXTERN gchar* audio_set_sink_default_volume_dec (Audio* self,
                                          gint volume);
VALA_EXTERN gchar* audio_set_sink_default_mute (Audio* self,
                                    gboolean mute);
VALA_EXTERN gchar* audio_set_sink_default_toggle_mute (Audio* self);
VALA_EXTERN void audio_state_callback (Audio* self,
                           pa_context* con);
VALA_EXTERN void audio_default_sink_callback (Audio* self,
                                  pa_context* c,
                                  pa_sink_info* i,
                                  gint eol);
VALA_EXTERN void audio_sinks_list_callback (Audio* self,
                                pa_context* context,
                                pa_sink_info* i,
                                gint eol);
VALA_EXTERN void audio_subscribe_callback (Audio* self,
                               pa_context* context,
                               pa_subscription_event_type_t e,
                               guint32 id);
VALA_EXTERN Audio* audio_new (void);
VALA_EXTERN Audio* audio_construct (GType object_type);
VALA_EXTERN gchar** audio_get_sinks (Audio* self,
                         gint* result_length1);
VALA_EXTERN const gchar* audio_get_default_sink_name (Audio* self);
VALA_EXTERN gint audio_get_default_sink_id (Audio* self);
VALA_EXTERN const gchar* audio_get_default_sink_icon_name (Audio* self);
VALA_EXTERN gint audio_get_default_sink_volume (Audio* self);
VALA_EXTERN gboolean audio_get_default_sink_mute (Audio* self);

G_END_DECLS

#endif
