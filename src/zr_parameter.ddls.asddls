@EndUserText.label: 'Parameter'
@AccessControl.authorizationCheck: #CHECK
define view entity ZR_Parameter
  as select from zparam
  association to parent ZR_Parameter_S as _ParamAll on $projection.SingletonId = _ParamAll.SingletonId
{

  key id              as Id,

      value           as Value,

      @Semantics.user.createdBy: true
      created_by      as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      etag_master     as EtagMaster,

      1               as SingletonId,

      _ParamAll

}
