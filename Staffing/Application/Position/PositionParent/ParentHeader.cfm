
<cfparam name="url.mode" default="regular">
<cfparam name="url.Caller" default="">

<cfif mode eq "workflow">
	<cf_actionlistingscript>
</cfif>

<cf_filelibraryscript>

<cfajaximport tags="cfform">

<cfif url.mode eq "direct">
	
	<cf_dialogPosition>		
	<cf_screentop jquery="Yes" scroll="Yes" html="Yes" banner="gray" line="No" height="100%" label="Position Parent and Loan History" layout="webapp">	
</cfif>

<cf_divscroll style="height:100%">	 

<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#URL.ID2#'	 
</cfquery>

<cfif PositionParent.recordcount eq "0">
    <cf_message message="Problem, Position could not be located. Please contact your administrator.">
    <cfabort>
</cfif>

<cfquery name="Current" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
   FROM  Ref_Mandate
   WHERE Mission = '#PositionParent.Mission#'
   AND   MandateNo = '#PositionParent.MandateNo#'
</cfquery>

<cfquery name="PositionChild" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	 *
	FROM 	 Position
	WHERE 	 PositionParentId = '#URL.ID2#' 
	ORDER BY DateEffective DESC
</cfquery>

<table width="100%"><tr><td style="padding:10px">

<table width="99%" align="center" class="formpadding">

   <tr><td height="5"></td></tr>
   <tr class="noprint">
   
    <td height="24" style="padding-left:6px;padding-right:4px">
	
		<cfoutput>	
		<table class="formpadding">
		<tr class="labelmedium2">
		    <td style="padding-left:5px"><cf_tl id="PostNumber">:</td>
			<td style="padding-left:5px;font-size:15px"><b>#PositionChild.SourcePostNumber#</b></td>
			<td style="padding-left:10px"><cf_tl id="Mandate">:</td>
			<td><b>#Current.Description#</b></td>
			<td style="padding-left:10px"><cf_tl id="Period">:</td>
			<td style="padding-left:5px"><b>#DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)#</b></td>
		</tr>
		</table>	
		</cfoutput>
		
    </td>
	
	<td align="right">
	
	<cfinvoke component="Service.Access"  
	  method="position" 
	  orgunit="#PositionParent.OrgUnitOperational#" 
	  role="'HRPosition'"
	  posttype="#PositionParent.PostType#"
	  returnvariable="accessPosition">
  
  <cfinvoke component="Service.Access"  
	  method="position" 
	  orgunit="#PositionParent.OrgUnitOperational#" 
	  role="'HRLoaner'"
	  posttype="#PositionParent.PostType#"
	  returnvariable="accessLoaner">
	  		
	<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
	
	        <table cellspacing="0" cellpadding="0">
			
			<tr>
			
				<cfoutput>
			
				<td>
				<cf_img icon="open" onclick="EditParentPosition('#PositionParent.Mission#','#PositionParent.MandateNo#','#PositionParent.PositionParentId#')">
				</td>
											
				<td style="padding-left:7px;padding-right:10px" class="labelmedium">	
										
				<cf_tl id="Parent Position" var="1">  
				<a href="javascript:EditParentPosition('#PositionParent.Mission#','#PositionParent.MandateNo#','#PositionParent.PositionParentId#')">
				#lt_text#</a>
				</td>
				
				</cfoutput>
			
			</tr>
			
			</table>

	</cfif>
			
	</td>
  </tr> 	
     
  <cfoutput>
    <input type="hidden" id="refresh_positionparent" 
       onclick="ptoken.navigate('#session.root#/Staffing/Application/Position/PositionParent/getPositionParent.cfm?ID2=#url.id2#','positionparentbox')">     
  </cfoutput> 	
 
  <tr>  
    <td width="100%" align="center" colspan="2" id="positionparentbox"><cfinclude template="getPositionParent.cfm"></td>		
  </tr>
  	 	  
  <tr>
       <td height="5" colspan="2" style="padding-left:35px;padding-right:9px">
	     <cfset url.id = url.id2>
		 <cfinclude template="../Funding/PositionEdition.cfm">		
	   </td>       
  </tr>
	  	  
	<!--- check if workflow is defined --->
		
	<cfquery name="FlowDefined" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_EntityClassPublish
		 WHERE   EntityCode = 'PostClassification' 
		 AND     EntityClass = 'Standard'
	</cfquery>		
		
	<cfquery name="CheckMission" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Ref_EntityMission 
		 WHERE    EntityCode     = 'PostClassification'  
		 AND      Mission        = '#PositionParent.Mission#' 
	</cfquery>	
		
	<cfif FlowDefined.recordcount neq "0" 
	   and CheckMission.WorkflowEnabled eq "1" 
	   and CheckMission.recordcount eq "1">	
		  
	<tr class="labelmedium"><td colspan="1" style="font-size:17px;padding-left:18px;height:30px">
	
		<cf_tl id="Classification">
	
		<cfoutput> 
	
	    <cfset url.ajaxid = url.id2>	
		
	    <cf_wfActive entityCode="PostClassification" objectkeyvalue1="#url.id2#">		
		
			 <cfinvoke component    = "Service.Access"  
				   method           = "createwfobject" 
				   entitycode       = "PostClassification"
				   mission          = "#PositionParent.Mission#"
				   returnvariable   = "accesscreate">   
				   
			<cfif accesscreate eq "EDIT" or accesscreate eq "ALL">		   		  
	   										 
			    <cfif wfStatus eq "Closed" or wfStatus eq "Open">					  
				
				   <td colspan="3" valign="bottom" align="right" style="padding-right:7px"> 
				   <cfif wfStatus eq "Closed">			   
				   <a id="classificationadd" href="javascript:	ProsisUI.createWindow('classify', 'Record Classification', '',{x:100,y:100,height:500,width:840,modal:true,center:true});ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/ParentClassification.cfm?class=init&positionparentid=#url.id2#&ajaxid=#url.ajaxid#','classify')">
				   <cf_tl id="Initiate post classification">
				   </a>	 			   
				   </cfif>
				   <cfif wfStatus eq "Open">
				   <a id="classificationdelete" style="color:red" href="javascript:Prosis.busy('yes');ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/ParentClassificationWorkflow.cfm?class=delete&positionparentid=#url.id2#&ajaxid=#url.ajaxid#','#url.ajaxid#')">
				     <cf_tl id="Remove classification workflow">
				   </a>	 
				   </cfif>
				   </td>
			     </tr>  				  
				 
			    </cfif>	
			
			</cfif>
			
			</td></tr> 
						
			<input type="hidden" 
			   name="workflowlink_#url.ajaxid#" 
			   id="workflowlink_#url.ajaxid#" 		   
			   value="ParentClassificationWorkflow.cfm">	
		
			<tr>		
			<td colspan="4" id="#url.ajaxid#">				
																		 
			   <cfif wfStatus eq "Open" or wfExist eq "1">				  
				   <cfinclude template="ParentClassificationWorkflow.cfm"> 
			   </cfif>
							
			</td>
			</tr>
				
		</cfoutput> 
	
	</cfif>
				
	<tr><td colspan="4" class="labellarge line" style="font-size:23px;padding-left:18px;height:40px"><cf_tl id="Position, Loan and usage history"></td></tr> 	
	     
	<tr> 
	
	<td width="100%" colspan="4" style="padding-left:10px">
    <table width="98%" align="center">
	
	<tr class="labelmedium2 fixrow" style="height:20px">
	<td width="5%"></td>
	<td width="50"><cf_tl id="Effective"></td>
	<td width="50"><cf_tl id="Expiration"></td>
	<td><cf_tl id="Position"></td>
	</tr>
	
	<cfif PositionChild.recordcount eq "0">
	
		<tr>
		 <td width="100%" colspan="4" class="line"></td>
	    </tr>  
		<tr>
		 <td class="labelmedium" width="100%" height="1" colspan="4" align="right">No positions found.</td>
	    </tr>  
	
	</cfif>
		
	<cfset prior = PositionParent.DateEffective-1>
		
	<cfoutput query = "PositionChild">
				
		<cfset str = "#PositionChild.DateEffective#+1-1">
		<cfset prior = prior + 1>
				
		<cfif str neq Prior>
	
	    	<cfif str gt prior>
	
		    <cfset strView   = DateFormat(PositionChild.DateEffective-1,CLIENT.DateFormatShow)>
	    	<cfset priorView = DateFormat(prior,CLIENT.DateFormatShow)>
		
		    <tr>
	     	<td width="5%" colspan="4" align="left" bgcolor="800000" class="labelmedium" class="top4n">&nbsp;<b>Alert</b> : Break in period from: <b>#PriorView#</b> &nbsp;until: <b>#StrView#</b></td>
	    	</tr>
				
			</cfif>
										
		</cfif>

		<tr class="line">
		 <td width="100%" colspan="4"></td>
	    </tr>   
								
		<tr class="labelmedium">
		  <td width="5%" valign="top" title="Instance:#PositionChild.PositionNo#" style="padding-top:3px;padding-left:10px">
		   <cf_img icon="open" title="Instance:#PositionChild.PositionNo#" onclick="javascript:EditPosition('#PositionChild.Mission#','#PositionChild.MandateNo#','#PositionChild.PositionNo#')">		   
		  </td>	    
		  <td width="100" style="padding-top:2px" valign="top">#DateFormat(PositionChild.DateEffective, CLIENT.DateFormatShow)#</td>
		  <td width="100" style="padding-top:2px" valign="top">#DateFormat(PositionChild.DateExpiration, CLIENT.DateFormatShow)#</td>
		  <td rowspan="2" valign="top"><cfinclude template="Position.cfm"></td>
		  	
		</tr>	
						
		<cfquery name="Error" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT    *
				FROM      AuditIncumbency
				WHERE     AuditSourceNo = '#PositionNo#' 
				AND       AuditElement  = 'Position' 
	    </cfquery>
			   
		<tr><td colspan="3" height="5" align="center" >
		
		<cfif Error.recordcount gte "1">
		   
			   <cfloop query="Error">
				   <table width="100%" border="0" cellspacing="0" cellpadding="0" 
				   		bordercolor="C0C0C0" bgcolor="E2F2FA" class="formpadding">
				   		<tr><td align="center">
				   				<font color="FF0000">#Error.Observation#</td>
						</tr>
				   </table>
			   </cfloop>
		   		   			   
		</cfif>
		</td>
		</tr>
		 
		<cfif Assignment.recordcount gt "0">
		  
		  <tr>
			  <td></td>
			  <td colspan="3">

				  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
			
					  <cfloop query="Assignment">
					  					  
					  <tr class="labelmedium navigation_row" style="border-top:1px solid silver">
					   <td height="18" width="10%" style="padding-left:4px"><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
					   <td width="25%"  class="fixlength"><a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</a></td>
					   <td width="4%">#Gender#</td>
					   <td width="5%" style="padding-right:4px">#Nationality#</td>
					   <td width="20%" class="fixlength" style="padding-right:6px">#Description#</td>
					   <td width="5%" style="padding-right:6px">#Incumbency#</td>
					   <td width="7%">#dateFormat(Assignment.DateEffective,CLIENT.DateFormatShow)#</td>
					   <td width="7%">#dateFormat(Assignment.DateExpiration,CLIENT.DateFormatShow)#</td>
					   <td width="10%" class="fixlength">#Assignment.OfficerLastName# (#dateFormat(Assignment.Created,CLIENT.DateFormatShow)#)</td>
					  </tr>
					  
					  <cfif Assignment.OrgUnit neq PositionChild.OrgUnitOperational>
					 
					 
					  <tr class="labelit navigation_row_child">
					      
						  <td align="right" style="padding-right:4px"><cf_tl id="Work"></td>
					      <td colspan="8" style="color:FF0000">#OrgUnitCode# #OrgUnitName#</td>
						  
					  </tr>
					  
					  </cfif>
					  
					  <cfif Assignment.FunctionNo neq PositionChild.FunctionNo>
					 					 
					  <tr class="labelit navigation_row_child">
					      
						  <td align="right" style="padding-right:4px"><cf_tl id="Function"></td>
					      <td colspan="8" style="color:FF0000">#FunctionDescription#</td>
						  
					  </tr>
					  
					  </cfif>
					 
					 					 		 		  
					  <cfquery name="Error" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT    *
							FROM      AuditIncumbency
							WHERE     AuditElement  = 'Assignment' 
							AND       AuditSourceNo = '#AssignmentNo#' 
					   </cfquery>
						   
					   <cfif Error.recordcount gte "1">
						 
						   <cfloop query="Error">
						   <tr><td colspan="9" bgcolor="ffffbf" class="labelmedium">
						   <img src="#SESSION.root#/Images/join.gif" alt="" align="absmiddle" border="0">
						   <font color="FF0000">#Error.Observation#</td></tr>
						   </cfloop>
						 
						</cfif>
					  		 
					  </cfloop>
				  </table>
			  
		     </td>
		  </tr>
		
		</cfif>
					 					
		<cfset prior = PositionChild.DateExpiration>		

	</cfoutput>
	
	<!--- last post --->
		
	<cfset str = PositionParent.DateExpiration>
	
	<cfif str lt Prior and Prior neq "0">
			
	<cfset strView   = DateFormat(PositionParent.DateEffective,CLIENT.DateFormatShow)>
	<cfset priorView = DateFormat(prior-1,CLIENT.DateFormatShow)>
	
	<cfoutput>
	<tr>
	<td colspan="4" align="center" height="25" bgcolor="800000" class="labelmedium"><font color="FFFFFF">&nbsp;<b>Alert</b> : Position Exceeds the assignment period from: <b>#priorView#</b> &nbsp;until: <b>#strView#</font></b></td>
	</tr>
	</cfoutput>
	
	</cfif>
	
	</table>
	</td>
	</tr>
			   
    </table>
	
	</td></tr></table>
		
    </td>
    </tr>
 
</table>
</cf_divscroll>	

<cfif url.mode eq "direct">
	<cf_screenBottom layout="webapp">
</cfif>

<cfset ajaxonload("doHighlight")>
