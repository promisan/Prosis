<HTML><HEAD>
<TITLE>Fields</TITLE>
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset cnt = 0>

<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   DISTINCT *
    FROM     Ref_EntityActionParent
	WHERE    EntityCode = '#URL.EntityCode#' 
	ORDER BY Owner,ListingOrder
</cfquery>

<cfquery name="Owner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AuthorizationRoleOwner	
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">  
</cfif>

<cfparam name="URL.owner" default="">  
	
<cfform action="ActionParentSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#URL.ID2#" method="POST" enablecab="Yes" name="action">

<div style="position:absolute;top:0; overflow: auto; width:100%; height:100%; scrollbar-face-color: F4f4f4; clip: auto;">

	<table width="97%" border="0" 
		cellspacing="0"  
		cellpadding="0"
		class="formspacing"
       	align="center">
   
	  <tr>
	    <td width="100%">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			
	    <TR class="labelmedium line">
		   <td height="18" width="8%">&nbsp;Code</td>
		   <td width="70%">Description</td>
		   <td width="6%">Order</td>
		   <td width="10%" align="center">Active</td>
		   <td width="7%" align="center"></td>
		   <td width="7%"></td>
	    </TR>	
				
		<cfset cnt = cnt + 30>
			
		<cfoutput query="Detail" group="Owner">
				
		
		<tr class="labelmedium line"><td height="1" colspan="5" style="padding-left:3px">#Owner#</td>
		     <td class="labelit">
		     <cfif URL.ID2 neq "new">
			     <A href="ActionParent.cfm?EntityCode=#URL.EntityCode#&ID2=new&owner=#owner#"><font color="0080FF">[add]</a>
			 </cfif>
			 </td>
		</tr>
				
		<cfif URL.ID2 eq "new" and url.owner eq Owner>
				   
		   <input type="hidden" name="Owner" id="Owner" value="#owner#">
					
			<TR bgcolor="ffffdf" class="labelmedium line">
			<td style="padding-left:3px">
			  <cfinput type="Text" value="" name="Code" message="You must enter a code" required="Yes" size="4" maxlength="6" class="regularxl">
	        </td>
			
			<td>
			   <cfinput type="Text" name="Description" message="You must enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
			</td>
			
			<td>
			   <cfinput type="Text" name="ListingOrder" validate="integer" required="No" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regularxl">
			</td>
			
			<td align="center">
				<input type="checkbox" name="Operational" id="Operational" value="1" checked>
			</td>		
											   
			<td align="right" colspan="2" style="padding-right:4px"><input type="submit" value="Add" class="button10g" style="height:25;width:60"></td>
			    
			</TR>	
						 			
			<cfset cnt = cnt + 25>
																	
		</cfif>	
		
		<cfoutput>
				
		<cfset cnt = cnt + 31>
								
		<cfset cd   = Code>
		<cfset de   = Description>
		<cfset op   = Operational>
		<cfset ord  = ListingOrder>
														
		<cfif URL.ID2 eq cd and url.owner eq owner>
		
		    <input type="hidden" name="Code" id="Code" value="#cd#">
			<input type="hidden" name="Owner" id="Owner" value="#owner#">
												
			<TR bgcolor="ffffaf" style="height:30px" class="labelmedium line">
			   <td style="height:25px;padding-left:4px">#cd#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="Description" message="You must enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
	           </td>
			   <td>
			      <cfinput type="Text" value="#ord#" name="ListingOrder" validate="integer" style="text-align:center;min-width:30" required="No" visible="Yes" maxlength="2" class="regularxl">&nbsp;
			   </td>
			   <td align="center">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				</td>
			   <td colspan="2" align="right" style="padding-right:4px"><input type="submit" style="width:60;height:25" value="Update" class="button10g"></td>
		    </TR>	
					
		<cfelse>		
			
			<TR class="labelmedium line">
			
			   <td height="15" style="padding-left:7px">#cd#</td>
			   <td>#de#</td>
			   <td>#ord#</td>					   
			   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td align="center" style="padding-right:4px">
			     <a href="ActionParent.cfm?EntityCode=#URL.EntityCode#&ID2=#cd#&owner=#owner#"><font color="0080C0">[edit]</font></a>
			   </td>
			   <td width="30" align="center" style="padding-top:4px">
		
				<cfquery name="Detail" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_EntityAction
					WHERE EntityCode  = '#EntityCode#'
					AND   ParentCode  = '#cd#'
				</cfquery>
				   
			    <cfif Detail.recordcount eq "0">
			    <a href="ActionParentPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#cd#&owner=#owner#">
				<img src="#SESSION.root#/images/delete5.gif" alt="Delete" width="12" height="12" border="0" align="absmiddle">
				</a>
				</cfif>
			
			  </td>
			   
		    </TR>				
					
		</cfif>
						
		</cfoutput>
		
		</cfoutput>
					
		</table>
		</td>
		</tr>
							
	</table>	
	
	</div>

</cfform>

<cfif cnt lt "250">	
		
	<cfoutput>
	<script language="JavaScript">
	
	{
	
	frm  = parent.document.getElementById("ipar");
	frm.height = #cnt#
	}
	
	</script>
	</cfoutput>
	
	</cfif>
