

<cfquery name="Detail" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   I.*, S.Description as DescriptionClass
	FROM     ServiceItem I, ServiceItemClass S
	WHERE    I.ServiceClass = S.Code
	AND      I.Code = '#URL.ServiceItem#'	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_ParameterMission
	WHERE   Mission   = '#url.Mission#'
</cfquery>

<!--- delete any cart entries that are not submitted --->

<cfquery name="Clear" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE  FROM Cart
	WHERE   OfficerUserId = '#client.acc#'
	AND     ActionStatus = '0'	
</cfquery>
		
<CFOUTPUT query="Detail">	
	
	<table width="99%" class="formpadding" cellspacing="0" cellpadding="0">
	    
		<tr><td height="4"></td></tr>
		
		<tr class="line">
		  <td height="36" class="labellarge">
		  <img src="#SESSION.Root#/Images/Cart/Back.png" alt="Back" style="cursor:hand" border="0" onClick="go.click()">
		  </td>
		  <td class="labellarge"><font color="black"><b>#Description#</b></font></TD>
		  <td><img src="<cfoutput>#SESSION.Root#</cfoutput>/images/cart.JPG" alt="" border="0" align="right"></td>
		</tr>
				
		<tr><td colspan="3" height="8"></td></tr>	
		
	</table>

</cfoutput>



<CFOUTPUT query="Detail">

	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
	    <td width="330" align="center" valign="top">	
		
		  <!---		hanno 14/1/2014 this is slowing down somehow 
		  
		 <cfif FileExists("#SESSION.RootDocumentPath#WorkOrder/Pictures/#Code#.jpg")>		 
		 
		       <!--- slow 
			   
		       <cftry>
			   
			   <cfinvoke component="Service.Image.CFImageEffects" method="init" returnvariable="effects">
			   
		       <cfimage 
					  action="RESIZE" 
					  source="#SESSION.RootDocument#WorkOrder/Pictures/#Code#.jpg" 
					  name="showimage" 
					  height="200" 
					  width="340">					 
					  
					  <cfset showimage = effects.applyReflectionEffect(showimage, "white", 60)>
					  
					  <cfimage 
					  action="WRITETOBROWSER" source="#showimage#">
					  
				<cfcatch>
				
				--->
				
				  <b><img src="#SESSION.RootDocument#WorkOrder/Pictures/#Code#.jpg"
					     alt="#ItemDescription#"
					     width="340"
					     height="220"
					     border="0"
					     align="absmiddle">
				  </b>
				  
				  <!---
				</cfcatch>	  
				
				</cftry>
				
				--->
		 
		  	 <cfelse>		
			 
			 ---> 
			 
			  <b><img src="#SESSION.Root#/images/image-not-found.gif" alt="#Description#" border="0" align="absmiddle"></b>
			  
			 <!--- 
			  
		 </cfif>
		 
		 --->
				 
		</td>
	
		
		<td valign="top">
				
	    <table width="100%" valign="header" border="0" class="formpadding" cellpadding="0" cellspacing="0">
					 
	        <input type="hidden" name="serviceitem" value="#URL.ServiceItem#"> 
			<!--- can be removed 
			<input type="hidden" name="unit" value="#URL.ServiceItemUnit#"> 
			--->
	    
		  <!---
		  <tr><td height="2"></td></tr>
		  <tr>
	        <TD height="20" width="130">&nbsp;<cf_tl id="Quantity">:</TD>
			<TD height="20"></TD>
	        <TD height="20"><input type="text" name="quantity" value="1" size="4" maxlength="8" style="text-align: center;"> #Detail.UoMDescription# </TD> 
	      </TR>
		  --->	
		  
		  <tr>
	        <TD height="20" class="labelmedium"><cf_tl id="Category">:</TD>
			<TD height="20"></TD>
	        <TD height="20" class="labelmedium" width="70%">#DescriptionClass#</TD>
	      </tr>
		  
		  <!---
		  
		  <cfif Parameter.PortalInterfaceMode neq "Internal">
			  <tr>
		        <TD height="20">&nbsp;<cf_tl id="Classification">:</TD>
				<TD height="20"></TD>
		        <TD height="16">#Classification# [#ItemNo#]</TD>
		      </tr>
			  <tr>
		        <TD height="20">&nbsp;<cf_tl id="Color">:</TD>
				<TD height="20"></TD>
		        <TD height="20"><cfif itemcolor neq "">#ItemColor#<cfelse>N/A</cfif></TD>
		      </tr>
			  <tr>
		    	<TD height="20">&nbsp;<cf_tl id="Class">:</TD>
				<TD height="20">&nbsp;</TD>
		        <TD height="20">#ItemClass#</TD>
		      </tr>
		  </cfif>
		  
		  --->
		  
		   <tr>
	        <TD height="20" class="labelmedium"><cf_tl id="Details">:</TD>
			<TD height="20"></TD>
	        <td height="20" class="labelmedium">#Memo#</td>
	      </tr>
		
		  <tr><td class="line" colspan="3"></td></tr>
		 		  
		  <tr><td colspan="3">
		  
			  <table width="100%" align="center">
					
			  	<tr><td align="center" id="detaillines" valign="top">
				
				  <!--- select the cartlines of the same item, which are not submitted yet = 0 --->
				  <cfset url.serviceitem = serviceitem>		
				  
				  <form name="formlines">
				   
				  <cfinclude template="CartLine.cfm">				
				  				  				  
				  </form>	
				
				</td></tr>
				
			  </table>		  
		  
		  </td></tr>
		  
		  <tr><td class="line" colspan="3"></td></tr>
		  		  
		  <tr>
		    <td height="20" class="labelmedium"><cf_tl id="Memo">:</td>
		    <TD height="20">&nbsp;</TD>
	        <TD height="20"><input class="regularxl" type="text" name="memo" size="60" maxlength="60"></td>
		  </tr>		
		  		
	      </table>
		 		  
		  </td>    
	   </tr>
	   <tr><td colspan="3" align="right" style="width:100%;padding-top:4px">	  	   
	   			<cfinclude template="CartAddDetail.cfm">	   	  	   	   
	   </td></tr>	   
	  
	   <tr><td height="10"></td></tr>
	  
	   <tr><td colspan="3" align="center">
		 <img src="#SESSION.Root#/Images/Cart/Back.png" alt="Back" style="cursor:hand;cursor:pointer" border="0" onClick="go.click()">
		 <img src="#SESSION.Root#/Images/Cart/AddCart.png" alt="Back" style="cursor:hand;cursor:pointer" border="0" onClick="addtocart()">	     
		  </td>
	   </tr>
	   
</table>
</cfoutput>
