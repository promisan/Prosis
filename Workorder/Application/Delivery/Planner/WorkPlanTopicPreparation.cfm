<cfparam name="URL.PositionNo" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>
	
 <cfquery name="gettopic"
   datasource="appsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">  
   SELECT    PositionNo, 
             PersonNo, 
       
       (SELECT TOP 1 ListCode 
        FROM   WorkPlanTopic  
        WHERE  WorkPlanId = W.WorkPlanId 
        AND    Topic = 'f004' 
        AND    Operational = 1 ) as ListCode
       
      
   FROM      WorkPlan W     
   WHERE     
   <cfif URL.positionNo neq "">
	   PositionNo = '#url.positionno#'
	   AND       
   </cfif> 
   Mission    = '#url.mission#'
   AND       DateEffective = #DTS#
   AND       DateExpiration = #DTS#
  </cfquery> 
  
  <cfoutput>
  <cfloop query="gettopic">
  	<input type="hidden" name="f004_#gettopic.positionNo#" id="f004_#gettopic.positionNo#" value="#gettopic.ListCode#">
  </cfloop>
  </cfoutput>
 