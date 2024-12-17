@EndUserText.label: 'Maintain Parameter'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_Parameter
  as projection on ZR_Parameter
{


  key Id,

      Value,

      CreatedBy,

      CreatedAt,

      LastChangedBy,

      LastChangedAt,

      @Consumption.hidden: true
      EtagMaster,

      @Consumption.hidden: true
      SingletonId,

      _ParamAll : redirected to parent ZC_Parameter_S

}
