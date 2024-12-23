/* Upower.c generated by valac 0.56.16, the Vala compiler
 * generated from Upower.vala, do not modify */

#include "Upower.h"
#include <glib.h>
#include <stdlib.h>
#include <string.h>
#include "Utils.h"
#include <glib-object.h>

#if !defined(VALA_STRICT_C)
#if !defined(__clang__) && defined(__GNUC__) && (__GNUC__ >= 14)
#pragma GCC diagnostic warning "-Wincompatible-pointer-types"
#elif defined(__clang__) && (__clang_major__ >= 16)
#pragma clang diagnostic ignored "-Wincompatible-function-pointer-types"
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
#endif
#endif

enum  {
	UPOWER_0_PROPERTY,
	UPOWER_BATTERY_LEVEL_PROPERTY,
	UPOWER_STATE_PROPERTY,
	UPOWER_TIME_REMAINING_PROPERTY,
	UPOWER_ICON_NAME_PROPERTY,
	UPOWER_NUM_PROPERTIES
};
static GParamSpec* upower_properties[UPOWER_NUM_PROPERTIES];
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
enum  {
	UPOWER_SIG_BATTERY_LEVEL_CHANGE_SIGNAL,
	UPOWER_SIG_STATE_CHANGE_SIGNAL,
	UPOWER_SIG_ICON_NAME_CHANGE_SIGNAL,
	UPOWER_SIG_TIME_CHANGE_SIGNAL,
	UPOWER_NUM_SIGNALS
};
static guint upower_signals[UPOWER_NUM_SIGNALS] = {0};

struct _UpowerPrivate {
	gint _battery_level;
	gchar* _state;
	gchar* _time_remaining;
	gchar* _icon_name;
};

static gint Upower_private_offset;
static gpointer upower_parent_class = NULL;

static void upower_update (Upower* self);
static void __lambda4_ (Upower* self,
                 const gchar* output);
static void ___lambda4__utils_exec_threads_output (UtilsExec_Threads* _sender,
                                            const gchar* o,
                                            gpointer self);
static void upower_set_battery_level (Upower* self,
                               gint value);
static void upower_set_state (Upower* self,
                       const gchar* value);
static void upower_set_time_remaining (Upower* self,
                                const gchar* value);
static void upower_set_icon_name (Upower* self,
                           const gchar* value);
static void upower_finalize (GObject * obj);
static GType upower_get_type_once (void);
static void _vala_upower_get_property (GObject * object,
                                guint property_id,
                                GValue * value,
                                GParamSpec * pspec);
static void _vala_upower_set_property (GObject * object,
                                guint property_id,
                                const GValue * value,
                                GParamSpec * pspec);
static void _vala_array_destroy (gpointer array,
                          gssize array_length,
                          GDestroyNotify destroy_func);
static void _vala_array_free (gpointer array,
                       gssize array_length,
                       GDestroyNotify destroy_func);
static gssize _vala_array_length (gpointer array);

static inline gpointer
upower_get_instance_private (Upower* self)
{
	return G_STRUCT_MEMBER_P (self, Upower_private_offset);
}

static gboolean
string_contains (const gchar* self,
                 const gchar* needle)
{
	gchar* _tmp0_;
	gboolean result;
	g_return_val_if_fail (self != NULL, FALSE);
	g_return_val_if_fail (needle != NULL, FALSE);
	_tmp0_ = strstr ((gchar*) self, (gchar*) needle);
	result = _tmp0_ != NULL;
	return result;
}

static void
__lambda4_ (Upower* self,
            const gchar* output)
{
	gboolean _tmp0_ = FALSE;
	g_return_if_fail (output != NULL);
	if (string_contains (output, "device changed")) {
		_tmp0_ = string_contains (output, "/org/freedesktop/UPower/devices/battery_BAT0");
	} else {
		_tmp0_ = FALSE;
	}
	if (_tmp0_) {
		upower_update (self);
	}
}

static void
___lambda4__utils_exec_threads_output (UtilsExec_Threads* _sender,
                                       const gchar* o,
                                       gpointer self)
{
	__lambda4_ ((Upower*) self, o);
}

void
upower_start (Upower* self)
{
	gchar** command = NULL;
	gchar* _tmp0_;
	gchar* _tmp1_;
	gchar** _tmp2_;
	gint command_length1;
	gint _command_size_;
	UtilsExec_Threads* thread = NULL;
	UtilsExec_Threads* _tmp3_;
	g_return_if_fail (self != NULL);
	upower_update (self);
	_tmp0_ = g_strdup ("upower");
	_tmp1_ = g_strdup ("--monitor");
	_tmp2_ = g_new0 (gchar*, 2 + 1);
	_tmp2_[0] = _tmp0_;
	_tmp2_[1] = _tmp1_;
	command = _tmp2_;
	command_length1 = 2;
	_command_size_ = command_length1;
	_tmp3_ = utils_exec_threads_new (command, command_length1, "power");
	thread = _tmp3_;
	g_signal_connect_object (thread, "output", (GCallback) ___lambda4__utils_exec_threads_output, self, 0);
	utils_exec_threads_start (thread);
	_g_object_unref0 (thread);
	command = (_vala_array_free (command, command_length1, (GDestroyNotify) g_free), NULL);
}

static gchar*
string_chomp (const gchar* self)
{
	gchar* _result_ = NULL;
	gchar* _tmp0_;
	gchar* result;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = g_strdup (self);
	_result_ = _tmp0_;
	g_strchomp (_result_);
	result = _result_;
	return result;
}

static gchar*
string_chug (const gchar* self)
{
	gchar* _result_ = NULL;
	gchar* _tmp0_;
	gchar* result;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = g_strdup (self);
	_result_ = _tmp0_;
	g_strchug (_result_);
	result = _result_;
	return result;
}

static gchar*
string_slice (const gchar* self,
              glong start,
              glong end)
{
	glong string_length = 0L;
	gint _tmp0_;
	gint _tmp1_;
	gboolean _tmp2_ = FALSE;
	gboolean _tmp3_ = FALSE;
	gchar* _tmp4_;
	gchar* result;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = strlen (self);
	_tmp1_ = _tmp0_;
	string_length = (glong) _tmp1_;
	if (start < ((glong) 0)) {
		start = string_length + start;
	}
	if (end < ((glong) 0)) {
		end = string_length + end;
	}
	if (start >= ((glong) 0)) {
		_tmp2_ = start <= string_length;
	} else {
		_tmp2_ = FALSE;
	}
	g_return_val_if_fail (_tmp2_, NULL);
	if (end >= ((glong) 0)) {
		_tmp3_ = end <= string_length;
	} else {
		_tmp3_ = FALSE;
	}
	g_return_val_if_fail (_tmp3_, NULL);
	g_return_val_if_fail (start <= end, NULL);
	_tmp4_ = g_strndup (((gchar*) self) + start, (gsize) (end - start));
	result = _tmp4_;
	return result;
}

static void
upower_update (Upower* self)
{
	gchar* output = NULL;
	gchar* _tmp0_;
	gchar* _tmp1_;
	gchar* _tmp2_;
	gchar** _tmp3_;
	gchar** _tmp4_;
	gint _tmp4__length1;
	gchar* _tmp5_;
	gchar* _tmp6_;
	gchar* output_type = NULL;
	gchar* output_value = NULL;
	const gchar* _tmp7_;
	gchar** _tmp8_;
	gchar** _tmp9_;
	g_return_if_fail (self != NULL);
	_tmp0_ = g_strdup ("upower");
	_tmp1_ = g_strdup ("-i");
	_tmp2_ = g_strdup ("/org/freedesktop/UPower/devices/battery_BAT0");
	_tmp3_ = g_new0 (gchar*, 3 + 1);
	_tmp3_[0] = _tmp0_;
	_tmp3_[1] = _tmp1_;
	_tmp3_[2] = _tmp2_;
	_tmp4_ = _tmp3_;
	_tmp4__length1 = 3;
	_tmp5_ = utils_exec (_tmp4_, (gint) 3);
	_tmp6_ = _tmp5_;
	_tmp4_ = (_vala_array_free (_tmp4_, _tmp4__length1, (GDestroyNotify) g_free), NULL);
	output = _tmp6_;
	_tmp7_ = output;
	_tmp9_ = _tmp8_ = g_strsplit (_tmp7_, "\n", 0);
	{
		gchar** str_collection = NULL;
		gint str_collection_length1 = 0;
		gint _str_collection_size_ = 0;
		gint str_it = 0;
		str_collection = _tmp9_;
		str_collection_length1 = _vala_array_length (_tmp8_);
		for (str_it = 0; str_it < str_collection_length1; str_it = str_it + 1) {
			gchar* _tmp10_;
			gchar* str = NULL;
			_tmp10_ = g_strdup (str_collection[str_it]);
			str = _tmp10_;
			{
				const gchar* _tmp11_;
				gchar** _tmp12_;
				gchar** _tmp13_;
				gchar** _tmp14_;
				gint _tmp14__length1;
				const gchar* _tmp15_;
				gchar* _tmp16_;
				const gchar* _tmp17_;
				gchar** _tmp18_;
				gchar** _tmp19_;
				gchar** _tmp20_;
				gint _tmp20__length1;
				const gchar* _tmp21_;
				gchar* _tmp22_;
				gboolean _tmp23_ = FALSE;
				const gchar* _tmp24_;
				const gchar* _tmp26_;
				gchar* _tmp27_;
				gchar* _tmp28_;
				gchar* _tmp29_;
				const gchar* _tmp30_;
				gchar* _tmp31_;
				gchar* _tmp32_;
				gchar* _tmp33_;
				const gchar* _tmp34_;
				const gchar* _tmp35_;
				GQuark _tmp37_ = 0U;
				static GQuark _tmp36_label0 = 0;
				static GQuark _tmp36_label1 = 0;
				static GQuark _tmp36_label2 = 0;
				static GQuark _tmp36_label3 = 0;
				static GQuark _tmp36_label4 = 0;
				_tmp11_ = str;
				_tmp13_ = _tmp12_ = g_strsplit (_tmp11_, ":", 0);
				_tmp14_ = _tmp13_;
				_tmp14__length1 = _vala_array_length (_tmp12_);
				_tmp15_ = _tmp14_[0];
				_tmp16_ = g_strdup (_tmp15_);
				_g_free0 (output_type);
				output_type = _tmp16_;
				_tmp14_ = (_vala_array_free (_tmp14_, _tmp14__length1, (GDestroyNotify) g_free), NULL);
				_tmp17_ = str;
				_tmp19_ = _tmp18_ = g_strsplit (_tmp17_, ":", 0);
				_tmp20_ = _tmp19_;
				_tmp20__length1 = _vala_array_length (_tmp18_);
				_tmp21_ = _tmp20_[1];
				_tmp22_ = g_strdup (_tmp21_);
				_g_free0 (output_value);
				output_value = _tmp22_;
				_tmp20_ = (_vala_array_free (_tmp20_, _tmp20__length1, (GDestroyNotify) g_free), NULL);
				_tmp24_ = output_value;
				if (_tmp24_ == NULL) {
					_tmp23_ = TRUE;
				} else {
					const gchar* _tmp25_;
					_tmp25_ = output_type;
					_tmp23_ = _tmp25_ == NULL;
				}
				if (_tmp23_) {
					_g_free0 (str);
					continue;
				}
				_tmp26_ = output_type;
				_tmp27_ = string_chomp (_tmp26_);
				_tmp28_ = _tmp27_;
				_tmp29_ = string_chug (_tmp28_);
				_g_free0 (output_type);
				output_type = _tmp29_;
				_g_free0 (_tmp28_);
				_tmp30_ = output_value;
				_tmp31_ = string_chomp (_tmp30_);
				_tmp32_ = _tmp31_;
				_tmp33_ = string_chug (_tmp32_);
				_g_free0 (output_value);
				output_value = _tmp33_;
				_g_free0 (_tmp32_);
				_tmp34_ = output_type;
				_tmp35_ = _tmp34_;
				_tmp37_ = (NULL == _tmp35_) ? 0 : g_quark_from_string (_tmp35_);
				if (_tmp37_ == ((0 != _tmp36_label0) ? _tmp36_label0 : (_tmp36_label0 = g_quark_from_static_string ("percentage")))) {
					switch (0) {
						default:
						{
							const gchar* _tmp38_;
							gint _tmp39_;
							_tmp38_ = output_value;
							_tmp39_ = self->priv->_battery_level;
							if (atoi (_tmp38_) != _tmp39_) {
								const gchar* _tmp40_;
								gint _tmp41_;
								_tmp40_ = output_value;
								upower_set_battery_level (self, atoi (_tmp40_));
								_tmp41_ = self->priv->_battery_level;
								g_signal_emit (self, upower_signals[UPOWER_SIG_BATTERY_LEVEL_CHANGE_SIGNAL], 0, _tmp41_);
							}
							break;
						}
					}
				} else if (_tmp37_ == ((0 != _tmp36_label1) ? _tmp36_label1 : (_tmp36_label1 = g_quark_from_static_string ("state")))) {
					switch (0) {
						default:
						{
							const gchar* _tmp42_;
							const gchar* _tmp43_;
							_tmp42_ = output_value;
							_tmp43_ = self->priv->_state;
							if (g_strcmp0 (_tmp42_, _tmp43_) != 0) {
								const gchar* _tmp44_;
								const gchar* _tmp45_;
								_tmp44_ = output_value;
								upower_set_state (self, _tmp44_);
								_tmp45_ = self->priv->_state;
								g_signal_emit (self, upower_signals[UPOWER_SIG_STATE_CHANGE_SIGNAL], 0, _tmp45_);
							}
							break;
						}
					}
				} else if (_tmp37_ == ((0 != _tmp36_label2) ? _tmp36_label2 : (_tmp36_label2 = g_quark_from_static_string ("time to empty")))) {
					switch (0) {
						default:
						{
							const gchar* _tmp46_;
							const gchar* _tmp47_;
							_tmp46_ = output_value;
							_tmp47_ = self->priv->_time_remaining;
							if (g_strcmp0 (_tmp46_, _tmp47_) != 0) {
								const gchar* _tmp48_;
								const gchar* _tmp49_;
								_tmp48_ = output_value;
								upower_set_time_remaining (self, _tmp48_);
								_tmp49_ = self->priv->_time_remaining;
								g_signal_emit (self, upower_signals[UPOWER_SIG_TIME_CHANGE_SIGNAL], 0, _tmp49_);
							}
							break;
						}
					}
				} else if (_tmp37_ == ((0 != _tmp36_label3) ? _tmp36_label3 : (_tmp36_label3 = g_quark_from_static_string ("time to full")))) {
					switch (0) {
						default:
						{
							const gchar* _tmp50_;
							const gchar* _tmp51_;
							_tmp50_ = output_value;
							_tmp51_ = self->priv->_time_remaining;
							if (g_strcmp0 (_tmp50_, _tmp51_) != 0) {
								const gchar* _tmp52_;
								const gchar* _tmp53_;
								_tmp52_ = output_value;
								upower_set_time_remaining (self, _tmp52_);
								_tmp53_ = self->priv->_time_remaining;
								g_signal_emit (self, upower_signals[UPOWER_SIG_TIME_CHANGE_SIGNAL], 0, _tmp53_);
							}
							break;
						}
					}
				} else if (_tmp37_ == ((0 != _tmp36_label4) ? _tmp36_label4 : (_tmp36_label4 = g_quark_from_static_string ("icon-name")))) {
					switch (0) {
						default:
						{
							const gchar* _tmp54_;
							const gchar* _tmp55_;
							_tmp54_ = output_value;
							_tmp55_ = self->priv->_icon_name;
							if (g_strcmp0 (_tmp54_, _tmp55_) != 0) {
								const gchar* _tmp56_;
								gchar* _tmp57_;
								gchar* _tmp58_;
								const gchar* _tmp59_;
								_tmp56_ = output_value;
								_tmp57_ = string_slice (_tmp56_, (glong) 1, (glong) -1);
								_tmp58_ = _tmp57_;
								upower_set_icon_name (self, _tmp58_);
								_g_free0 (_tmp58_);
								_tmp59_ = self->priv->_icon_name;
								g_signal_emit (self, upower_signals[UPOWER_SIG_ICON_NAME_CHANGE_SIGNAL], 0, _tmp59_);
							}
							break;
						}
					}
				}
				_g_free0 (str);
			}
		}
		str_collection = (_vala_array_free (str_collection, str_collection_length1, (GDestroyNotify) g_free), NULL);
	}
	_g_free0 (output_value);
	_g_free0 (output_type);
	_g_free0 (output);
}

Upower*
upower_construct (GType object_type)
{
	Upower * self = NULL;
	self = (Upower*) g_object_new (object_type, NULL);
	return self;
}

Upower*
upower_new (void)
{
	return upower_construct (TYPE_UPOWER);
}

gint
upower_get_battery_level (Upower* self)
{
	gint result;
	g_return_val_if_fail (self != NULL, 0);
	result = self->priv->_battery_level;
	return result;
}

static void
upower_set_battery_level (Upower* self,
                          gint value)
{
	gint old_value;
	g_return_if_fail (self != NULL);
	old_value = upower_get_battery_level (self);
	if (old_value != value) {
		self->priv->_battery_level = value;
		g_object_notify_by_pspec ((GObject *) self, upower_properties[UPOWER_BATTERY_LEVEL_PROPERTY]);
	}
}

const gchar*
upower_get_state (Upower* self)
{
	const gchar* result;
	const gchar* _tmp0_;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->priv->_state;
	result = _tmp0_;
	return result;
}

static void
upower_set_state (Upower* self,
                  const gchar* value)
{
	gchar* old_value;
	g_return_if_fail (self != NULL);
	old_value = upower_get_state (self);
	if (g_strcmp0 (value, old_value) != 0) {
		gchar* _tmp0_;
		_tmp0_ = g_strdup (value);
		_g_free0 (self->priv->_state);
		self->priv->_state = _tmp0_;
		g_object_notify_by_pspec ((GObject *) self, upower_properties[UPOWER_STATE_PROPERTY]);
	}
}

const gchar*
upower_get_time_remaining (Upower* self)
{
	const gchar* result;
	const gchar* _tmp0_;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->priv->_time_remaining;
	result = _tmp0_;
	return result;
}

static void
upower_set_time_remaining (Upower* self,
                           const gchar* value)
{
	gchar* old_value;
	g_return_if_fail (self != NULL);
	old_value = upower_get_time_remaining (self);
	if (g_strcmp0 (value, old_value) != 0) {
		gchar* _tmp0_;
		_tmp0_ = g_strdup (value);
		_g_free0 (self->priv->_time_remaining);
		self->priv->_time_remaining = _tmp0_;
		g_object_notify_by_pspec ((GObject *) self, upower_properties[UPOWER_TIME_REMAINING_PROPERTY]);
	}
}

const gchar*
upower_get_icon_name (Upower* self)
{
	const gchar* result;
	const gchar* _tmp0_;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->priv->_icon_name;
	result = _tmp0_;
	return result;
}

static void
upower_set_icon_name (Upower* self,
                      const gchar* value)
{
	gchar* old_value;
	g_return_if_fail (self != NULL);
	old_value = upower_get_icon_name (self);
	if (g_strcmp0 (value, old_value) != 0) {
		gchar* _tmp0_;
		_tmp0_ = g_strdup (value);
		_g_free0 (self->priv->_icon_name);
		self->priv->_icon_name = _tmp0_;
		g_object_notify_by_pspec ((GObject *) self, upower_properties[UPOWER_ICON_NAME_PROPERTY]);
	}
}

static void
upower_class_init (UpowerClass * klass,
                   gpointer klass_data)
{
	upower_parent_class = g_type_class_peek_parent (klass);
	g_type_class_adjust_private_offset (klass, &Upower_private_offset);
	G_OBJECT_CLASS (klass)->get_property = _vala_upower_get_property;
	G_OBJECT_CLASS (klass)->set_property = _vala_upower_set_property;
	G_OBJECT_CLASS (klass)->finalize = upower_finalize;
	g_object_class_install_property (G_OBJECT_CLASS (klass), UPOWER_BATTERY_LEVEL_PROPERTY, upower_properties[UPOWER_BATTERY_LEVEL_PROPERTY] = g_param_spec_int ("battery-level", "battery-level", "battery-level", G_MININT, G_MAXINT, 0, G_PARAM_STATIC_STRINGS | G_PARAM_READABLE));
	g_object_class_install_property (G_OBJECT_CLASS (klass), UPOWER_STATE_PROPERTY, upower_properties[UPOWER_STATE_PROPERTY] = g_param_spec_string ("state", "state", "state", NULL, G_PARAM_STATIC_STRINGS | G_PARAM_READABLE));
	g_object_class_install_property (G_OBJECT_CLASS (klass), UPOWER_TIME_REMAINING_PROPERTY, upower_properties[UPOWER_TIME_REMAINING_PROPERTY] = g_param_spec_string ("time-remaining", "time-remaining", "time-remaining", NULL, G_PARAM_STATIC_STRINGS | G_PARAM_READABLE));
	g_object_class_install_property (G_OBJECT_CLASS (klass), UPOWER_ICON_NAME_PROPERTY, upower_properties[UPOWER_ICON_NAME_PROPERTY] = g_param_spec_string ("icon-name", "icon-name", "icon-name", NULL, G_PARAM_STATIC_STRINGS | G_PARAM_READABLE));
	upower_signals[UPOWER_SIG_BATTERY_LEVEL_CHANGE_SIGNAL] = g_signal_new ("sig-battery-level-change", TYPE_UPOWER, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_VOID__INT, G_TYPE_NONE, 1, G_TYPE_INT);
	upower_signals[UPOWER_SIG_STATE_CHANGE_SIGNAL] = g_signal_new ("sig-state-change", TYPE_UPOWER, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_VOID__STRING, G_TYPE_NONE, 1, G_TYPE_STRING);
	upower_signals[UPOWER_SIG_ICON_NAME_CHANGE_SIGNAL] = g_signal_new ("sig-icon-name-change", TYPE_UPOWER, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_VOID__STRING, G_TYPE_NONE, 1, G_TYPE_STRING);
	upower_signals[UPOWER_SIG_TIME_CHANGE_SIGNAL] = g_signal_new ("sig-time-change", TYPE_UPOWER, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_VOID__STRING, G_TYPE_NONE, 1, G_TYPE_STRING);
}

static void
upower_instance_init (Upower * self,
                      gpointer klass)
{
	self->priv = upower_get_instance_private (self);
	self->priv->_battery_level = 0;
}

static void
upower_finalize (GObject * obj)
{
	Upower * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, TYPE_UPOWER, Upower);
	_g_free0 (self->priv->_state);
	_g_free0 (self->priv->_time_remaining);
	_g_free0 (self->priv->_icon_name);
	G_OBJECT_CLASS (upower_parent_class)->finalize (obj);
}

static GType
upower_get_type_once (void)
{
	static const GTypeInfo g_define_type_info = { sizeof (UpowerClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) upower_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (Upower), 0, (GInstanceInitFunc) upower_instance_init, NULL };
	GType upower_type_id;
	upower_type_id = g_type_register_static (G_TYPE_OBJECT, "Upower", &g_define_type_info, 0);
	Upower_private_offset = g_type_add_instance_private (upower_type_id, sizeof (UpowerPrivate));
	return upower_type_id;
}

GType
upower_get_type (void)
{
	static volatile gsize upower_type_id__once = 0;
	if (g_once_init_enter (&upower_type_id__once)) {
		GType upower_type_id;
		upower_type_id = upower_get_type_once ();
		g_once_init_leave (&upower_type_id__once, upower_type_id);
	}
	return upower_type_id__once;
}

static void
_vala_upower_get_property (GObject * object,
                           guint property_id,
                           GValue * value,
                           GParamSpec * pspec)
{
	Upower * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, TYPE_UPOWER, Upower);
	switch (property_id) {
		case UPOWER_BATTERY_LEVEL_PROPERTY:
		g_value_set_int (value, upower_get_battery_level (self));
		break;
		case UPOWER_STATE_PROPERTY:
		g_value_set_string (value, upower_get_state (self));
		break;
		case UPOWER_TIME_REMAINING_PROPERTY:
		g_value_set_string (value, upower_get_time_remaining (self));
		break;
		case UPOWER_ICON_NAME_PROPERTY:
		g_value_set_string (value, upower_get_icon_name (self));
		break;
		default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
		break;
	}
}

static void
_vala_upower_set_property (GObject * object,
                           guint property_id,
                           const GValue * value,
                           GParamSpec * pspec)
{
	Upower * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, TYPE_UPOWER, Upower);
	switch (property_id) {
		case UPOWER_BATTERY_LEVEL_PROPERTY:
		upower_set_battery_level (self, g_value_get_int (value));
		break;
		case UPOWER_STATE_PROPERTY:
		upower_set_state (self, g_value_get_string (value));
		break;
		case UPOWER_TIME_REMAINING_PROPERTY:
		upower_set_time_remaining (self, g_value_get_string (value));
		break;
		case UPOWER_ICON_NAME_PROPERTY:
		upower_set_icon_name (self, g_value_get_string (value));
		break;
		default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
		break;
	}
}

static void
_vala_array_destroy (gpointer array,
                     gssize array_length,
                     GDestroyNotify destroy_func)
{
	if ((array != NULL) && (destroy_func != NULL)) {
		gssize i;
		for (i = 0; i < array_length; i = i + 1) {
			if (((gpointer*) array)[i] != NULL) {
				destroy_func (((gpointer*) array)[i]);
			}
		}
	}
}

static void
_vala_array_free (gpointer array,
                  gssize array_length,
                  GDestroyNotify destroy_func)
{
	_vala_array_destroy (array, array_length, destroy_func);
	g_free (array);
}

static gssize
_vala_array_length (gpointer array)
{
	gssize length;
	length = 0;
	if (array) {
		while (((gpointer*) array)[length]) {
			length++;
		}
	}
	return length;
}

