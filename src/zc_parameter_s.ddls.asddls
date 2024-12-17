@EndUserText.label: 'Maintain Parameter Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonId' ]
define root view entity ZC_Parameter_S
  provider contract transactional_query
  as projection on ZR_Parameter_S
{

  key SingletonId,

      LastChangedAtMax,

      TransportRequestID,

      HideTransport,

      _Param : redirected to composition child ZC_Parameter

}
