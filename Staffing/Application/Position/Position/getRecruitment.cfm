
<cfparam name="add" default="0">
<!--- 

   position recruitment tracks    
   active tracks and documentPostion records   
   --->
   
   <cfquery name="get" 
		  datasource="AppsVacancy" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		
   		    SELECT   *
			FROM     Employee.dbo.Position
			WHERE    PositionNo = '#url.id2#'			
   </cfquery>
   
   <cfquery name="getTrack" 
		  datasource="AppsVacancy" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		
   		   SELECT      TOP (200) D.DocumentNo, D.EntityClass, D.FunctionId,
	                           (SELECT     ReferenceNo
	                            FROM       Applicant.dbo.FunctionOrganization
			                    WHERE      FunctionId = D.FunctionId) AS ReferenceNo
			FROM       [Document] AS D INNER JOIN
			           DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
			WHERE      D.Status = '0' <!--- open --->
			AND        D.PositionNo IN (SELECT PositionNo 
			                            FROM   Employee.dbo.Position 
										WHERE  PositionParentId = '#get.PositionParentId#')			

   </cfquery>
   
   <table>
   <tr class="labelmedium2">
   
   <cfif add eq "1">
   <cfoutput>
   <cf_tl id="Add track" var="1">
   <td style="cursor:pointer;height:28px;padding-left:5px;padding-right:5px">
   <input type="button" value="#lt_text#" class="button10g" onClick="javascript:AddVacancy('<cfoutput>#url.id2#</cfoutput>','recruitment')">   
   </td>
   </cfoutput>
   </cfif>
   
   <cfoutput query="getTrack">
   
       <td style="height:28px;padding-left:5px;padding-right:5px;background-color:f1f1f1"><cfif currentrow neq "1">|</cfif>#EntityClass# <a href="javascript:showdocument('#documentNo#')"><cfif ReferenceNo eq "">#documentNo#<cfelse>#referenceno#</cfif></a></td>
      
   </cfoutput>
   
   </tr>
   </table>
