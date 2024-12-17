@EndUserText.label: 'Parameter Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZR_Parameter_S
  as select from    I_Language
    left outer join zparam on 0 = 0
  composition [0..*] of ZR_Parameter as _Param
{

  key 1                                          as SingletonId,

      _Param,

      max( zparam.last_changed_at )              as LastChangedAtMax,

      cast( '' as sxco_transport)                as TransportRequestID,

      cast( 'X' as abap_boolean preserving type) as HideTransport

}
where
  I_Language.Language = $session.system_language
