
<cfset deleted = deleteClientVariable("Sort")>

<cf_tl id="Personnel Action Assignment" var="1">

<cfoutput>

<cf_screenTop height="100%" jquery="Yes" border="0" banner="gray" line="no" html="No" label="#lt_text# #URL.Mission#" layout="webapp" scroll="no">
	 	 
<!--- <cf_ObjectControls> --->
<cf_LayoutScript>
<cfajaximport tags="cftree,cfform">	
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50"
		maxsize	  = "50"
		size 	  = "50">	
			  
		<cfinclude template="TransactionMenu.cfm">
			 			  
	</cf_layoutarea>		
	  
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "370" 		
		size        = "370" 
		collapsible = "true" 
		splitter    = "true">
				
		<cfset url.id = 0>			
				
		<cf_divscroll>
		
		<table width="100%" height="100%" class="tree" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		  <tr><td height="5" ></td></tr>
		  <tr><td valign="top">
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
			
			<cfform>
				
				<tr><td style="padding-left:7px">				
				<cf_staffingTransactionData>						
				</td></tr>
			
			</cfform>
			
			</table>
		
			</td>
		  </tr>
		
		</table>
		
		</cf_divscroll>
		
	
	</cf_layoutarea>
	
	<cf_layoutarea position="center" name="box">
				
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"				
				scrolling="no"
		        frameborder="0" 
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm">
		        </iframe>
					
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput> 


