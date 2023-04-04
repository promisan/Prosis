<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfparam name="url.jobno"    default="">
<cfparam name="url.actionId" default="">
<cfparam name="url.header"   default="no">
<cfparam name="url.mid"      default="">

<cfoutput>
	
	<cf_tl id="Record Obligation" var="vRecord">
	<cf_tl id="Select lines to be included in the obligation for the selected contractor" var="vSelectMessage">
		   
	<table width="100%" height="100%">
		<tr>		
			<td valign="top">
									
				<iframe src="#SESSION.root#/Procurement/Application/PurchaseOrder/Create/PurchaseCreate.cfm?Header=no&ActionId=#URL.actionId#&Jobno=#url.jobno#&Mission=#URL.Mission#&mid=#url.mid#"
			        name="right"
			        id="right"
			        width="100%"
			        height="99%"
					scrolling="no"
			        frameborder="0"></iframe>
					
			</td>
		</tr>
	</table>
	
</cfoutput>

