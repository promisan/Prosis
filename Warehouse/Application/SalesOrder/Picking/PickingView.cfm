<cfparam name="url.threshold"   default="0">
<cfparam name="url.ordering"    default="DESC">
<cfparam name="url.showDays"    default="1">

<cfoutput>
    <div style="height:101%;">
        <iframe 
            width="100%" 
            height="100%" 
            name="iPickingView"
            scroll="yes"
            frameborder="0"
            src="#session.root#/warehouse/application/salesorder/picking/picking.cfm?systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#&mission=#url.mission#&threshold=#url.threshold#&ordering=#url.ordering#&showDays=#url.showDays#">
    </div>
</cfoutput>