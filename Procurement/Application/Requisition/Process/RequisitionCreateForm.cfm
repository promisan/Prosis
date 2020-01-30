
<!--- submission window --->

<cf_DialogProcurement>
<cf_AnnotationScript>
<cf_DialogStaffing>

<cf_tl id="Submit Requests" var="vSubmit">
<cf_screentop height="100%" close="parent.parent.ColdFusion.Window.destroy('mysubmit',true)" label="#vSubmit#" jquery="Yes" line="no" banner="gray" layout="webapp" scroll="Yes" html="yes">

<cfoutput>

<script>

	function processsubmit(per) {
	    sta = document.getElementById('actionstatusselected').value
		Prosis.busy('yes')
		ptoken.navigate('../Process/RequisitionCreateSubmit.cfm?req=#url.req#&&status='+sta+'&mission=#URL.Mission#&period='+per,'process','','','POST','postrequest')			
	}

</script>

</cfoutput>

<cfparam name="Form.RequisitionNo" default="#url.req#">

<cfset req = "">
<cfloop index="itm" list="#Form.RequisitionNo#" delimiters="|">
    <cfif req neq "">
		<cfset req = "#req#,'#itm#'">
	<cfelse>
		<cfset req = "'#itm#'">		
	</cfif>
</cfloop>
		
<cfif req eq "">		
	<cf_message message="No lines were selected to be processed." return="No">			
<cfelse>	

<form method="post" name="postrequest" id="postrequest" height="100%">

<table width="100%" height="100%" bgcolor="white">

<tr><td id="process" align="center"></td></tr>

<tr><td valign="top">
	
	<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <cfif url.status eq "1">
		
			<cfset client.status = 1>
	
		    <tr><td height="7"></td></tr>
			<tr>
			<td></td>
			<td align="center" class="labellarge">
						
			<input type="hidden" name="actionstatusselected" id="actionstatusselected" value="1p">
			<table><tr class="labelmedium"><td>
			<input type="radio" class="radiol" name="actionstatusselect" id="actionstatusselect" 
				onclick="document.getElementById('actionstatusselected').value='1p'" value="1p" checked>
				</td>
				<td style="padding-left:5px;font-size:20px"><cf_tl id="Submit to reviewer"></td>
				<td style="padding-left:5px">
			<input type="radio" class="radiol" name="actionstatusselect" id="actionstatusselect" 
				onclick="document.getElementById('actionstatusselected').value='1f'" value="1f"></td>
				<td style="padding-left:5px;font-size:20px"><cf_tl id="Save as Forecast"> ( <cf_tl id="submit later"> )	</td></tr></table>
					
			</td>		
			</tr>
			
		<cfelse>
		
			<cfset client.status = "1f">
		
			<tr><td height="7"></td></tr>
			<tr>
			<td></td>
			<td class="labellarge" style="font-size:28px"><cf_tl id="Submit to reviewer"></td>		
			</tr>		
			<input type="hidden" name="actionstatusselected" id="actionstatusselected" value="1p">	
		
		</cfif>
		
		<tr>
		<td>
						
		<!--- additional query script --->
		
		<cfsavecontent variable="SubInfo">
		
			  (  SELECT count(*) 
				 FROM RequisitionLineTravel
				 WHERE RequisitionNo = L.RequisitionNo						 
			  )  as IndTravel,			  
			  
			  (  SELECT count(*)
				 FROM Employee.dbo.PositionParentFunding
		         WHERE RequisitionNo = L.RequisitionNo
			  )  as IndPosition,
			  	
			  (  SELECT count(*)
		         FROM RequisitionLineService
		         WHERE RequisitionNo = L.RequisitionNo
		      )  as IndService,		
			  
			  (  SELECT CustomDialog
		         FROM   Ref_EntryClass S2, ItemMaster S1
		         WHERE  S2.Code = S1.EntryClass
				 AND    S1.Code = L.ItemMaster
		         )  as CustomDialog,	
				 
			 (  SELECT count(*)
		 		FROM   RequisitionLineTopic R, Ref_Topic S
				 WHERE  R.Topic = S.Code
				  AND    S.Operational   = 1
				  AND    R.RequisitionNo = L.RequisitionNo) as CountedTopics,		 
				 
			 (  SELECT CustomForm
		         FROM ItemMaster
		         WHERE Code = L.ItemMaster
		         )  as CustomForm			 
						  
		</cfsavecontent>
			
		<cfquery name="Requisition" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT L.*, 
				       I.EntryClass,
					   #preservesinglequotes(subinfo)#,
					   
				
					   (SELECT  RequisitionPurpose 
				     	  FROM  Requisition
						 WHERE  Reference = L.Reference) as RequisitionPurpose,
				
					       (SELECT TOP 1  left(U.FirstName,1)+'. '+U.LastName 
						     FROM  RequisitionLineActor A, System.dbo.UserNames U
						     WHERE RequisitionNo = L.RequisitionNo
							 AND   A.ActorUserId = U.Account
						     AND   A.Role = 'ProcBuyer') as Buyer,
				      
					   S.Description as StatusDescription, 
					   ' ' as PurchaseNo, 
					   ' ' as PurchaseStatus, 
					   ' ' as Receipt
					   
									
				FROM    RequisitionLine L INNER JOIN
                    	Organization.dbo.Organization Org ON L.OrgUnit = Org.OrgUnit INNER JOIN
                        Status S ON S.StatusClass= 'Requisition' and L.ActionStatus = S.Status                                   
						INNER JOIN ItemMaster I ON L.ItemMaster = I.Code
															 
				WHERE L.RequisitionNo IN (#preserveSingleQuotes(req)#) 
				
				ORDER BY EntryClass, Reference																	
				
		   </cfquery>
		   		   
		<cfinvoke component="Service.Presentation.Presentation"
	       method="highlight"
	    returnvariable="stylescroll"/>

		<tr>
		 <td colspan="2">
		   
		   <cfset url.id = "whs">
		   <cfset url.id1 = "1">
		   <cfset url.lay = "">
		   <cfset url.view = "hide">
		   <cfset url.fun = "">
		   <cfset previous = "">
		   
		   <table width="100%" cellspacing="0" cellpadding="0">
		   
		   <cfoutput query="Requisition" group="EntryClass">
		   
		   	   <tr><td height="5"></td></tr>
		   
		  	   <tr><td height="25" 
			     style="border:0px solid gray" 
			     colspan="10"
			     bgcolor="f1f1f1">
				 <table width="100%" cellpadding="0">
				 <tr><td class="labelmedium" style="padding-left:4px">
				 <font color="gray"><cf_tl id="Request for">:</font><b>#EntryClass#				 
				 </td>
				 </tr></table>
				 </td></tr>			 
								 
				 <tr><td height="3"></td></tr>
			   			  			   
			   <cfoutput group="Reference">
			   			   			   
			   	   <cfset ref = reference>
			   			    
				   <cfoutput>
				       <cfset pt = 1>
					   <cfset url.id = "whs">
					   <cfinclude template="../RequisitionView/ListingDetail.cfm">		   
				  
					   <cfif ref neq "">
					   
					   		<input type="hidden" 
							    name="reassign#left(RequisitionId,8)#" 
                                id="reassign#left(RequisitionId,8)#"
								value="false">	   
				      
					  	 <tr><td></td><td align="right"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
						   <td height="18" colspan="7" align="center" bgcolor="yellow" style="border:1px solid d4d4d4">
					   
						   <table width="100%" cellspacing="0" cellpadding="0">
						   <tr>
						   <td>&nbsp;</td>
						   <td class="labelmedium">Request has been submitted before under <b><a title="view requisition" href="javascript:RequisitionView('#URL.Mission#','#URL.Period#','#Ref#')">#Reference#<a></b> and will be resubmitted</td>
						   <td align="right" class="labelmedium">Check to assign it a NEW Reference:</td>
						   <td style="padding-left:3px">
						   <input type="checkbox" class="radiol"
						     onclick="document.getElementById('Reassign#left(RequisitionId,8)#').value=this.checked" value="1">					 
						   </td>
						   </tr>
						   </table>
					   
						   </td>
						 </tr>
					   
					   </cfif>
				   
				    </cfoutput> 
				   
			   </cfoutput> 
			   
			   <tr><td height="5"></td></tr>
			   
		        <tr><td colspan="10">		
			  		<table width="100%">
					<tr><td valign="top" style="padding-top:1px" class="labelit"><cf_tl id="Comments">:</td>
					<td width="90%" style="padding-top:4px">
					    <textarea style="width:100%;padding:4px;font-size:12px" 
					     rows="5" id="RequisitionPurpose_#entryclass#" 
						 name="RequisitionPurpose_#entryclass#" 
						 class="regular"></textarea>
					</td>						
					</tr>										
					</table></td>
   	     	    </tr> 
			   
		   </cfoutput>
		   
		   </table>
		   		
		</td>
		</tr>	
	  		
		<cfoutput>
		
		<cf_tl id="Process" var="1">
		<cfset vSubmit=#lt_text#>
				
		<tr>
			<td colspan="2" align="center">
			   <input type="button" 
			      onclick="processsubmit('#url.period#')" 
				  style="width:160px;height:30px" 
				  name="PostData" 
                  id="PostData"
				  value="#vSubmit#" 
				  class="button10g">
			</td>
		</tr>	
		
		</cfoutput>
				
	</table>

</td></tr>

</table>

</form>

</cfif>

<cf_screenbottom layout="innerbox">