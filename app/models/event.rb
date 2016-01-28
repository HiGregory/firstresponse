class Event
  def initialize(raw_data)
    @raw_data = raw_data
  end

  def self.fields(*fields)
    fields.each_with_index do |field, index|
      define_method(field) { @raw_data[index] }
    end
  end

  fields \
    :go_id,
    :s_version,
    :s_template,
    :insert_time,
    :trans_type,
    :reported_on_date,
    :reported_on_time,
    :template_id,
    :report_year,
    :report_number,
    :version,
    :terry_stop_template,
    :event_rtype,
    :reported_by,
    :reported_by_trans,
    :event_rin,
    :chbk_dicv,
    :chbk_bodycam,
    :chbk_citoff_requested,
    :chbk_citoff_dispatched,
    :chbk_citoff_arrived,
    :chbk_biologically_induced,
    :chbk_medically_induced,
    :chbk_chemically_induced,
    :chbk_unknown_crisis_nature,
    :chbk_neglect_self_care,
    :chbk_disorganize_communication,
    :chbk_disoriented_confused,
    :chbk_disorderly_disruptive,
    :chbk_unusual_fright_scared,
    :chbk_belligerent_uncooperative,
    :chbk_hopeless_depressed,
    :chbk_bizarre_unusual_behavior,
    :chbk_suicide_threat_attempt,
    :chbk_mania,
    :chbk_out_of_touch_reality,
    :chbk_halluc_delusion,
    :chbk_behavior_other,
    :chbk_wpn_knife,
    :chbk_wpn_gun,
    :chbk_wpn_oth,
    :chbk_verbalization,
    :chbk_handcuffs,
    :chbk_reportable_force_used,
    :chbk_dispo_unable_to_contact,
    :chbk_dispo_chronic,
    :chbk_dispo_treatment_referral,
    :chbk_dispo_resource_declined,
    :chbk_dispo_mobile_crisis_team,
    :chbk_dispo_grat,
    :chbk_dispo_shelter,
    :chbk_dispo_no_action_poss_necc,
    :chbk_dispo_casemanager_notice,
    :chbk_dispo_dmhp_refer,
    :chbk_dispo_crisis_clinic,
    :chbk_dispo_emergent_ita,
    :chbk_dsipo_voluntary_commit,
    :chbk_dispo_arrested,
    :cit_certified_yn,
    :supv_responded_scene_yn,
    :crisis_contacted_last_name,
    :crisis_contacted_first_name,
    :crisis_contacted_vet_yn_unk,
    :other_behavior_descr,
    :weapon_yn_dk,
    :other_weapon_type,
    :threaten_violence_yn_dk,
    :threatened_whom,
    :injuries_yn_dk,
    :injury_desc,
    :invol_hospital_transport_to,
    :vol_hospital_transport_to,
    :no_arr_but_chargeable_yn,
    :chbk_excited_delirium

  def go_id
    @raw_data[0].strip
  end

  def to_s
    "Event #{go_id.strip}"
  end

  def inspect
    "<#{to_s} #{reported_on_date} #{reported_on_time}>"
  end

  def name
    "#{crisis_contacted_first_name} #{crisis_contacted_first_name}"
  end

  def to_partial_path
    "events/event"
  end
end
