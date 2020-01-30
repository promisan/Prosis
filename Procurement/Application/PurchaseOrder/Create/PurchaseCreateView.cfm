<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfparam name="url.jobno" default="">
<cfparam name="url.actionId" default="">

<cfoutput>
	
	<cf_tl id="Record Obligation" var="vRecord">
	<cf_tl id="Select lines to be included in the obligation for the selected contractor" var="vSelectMessage">
	
	<cf_screenTop height="100%" 
	   layout="webapp" 
	   bannerheight="60"
	   banner="gray"	   	   
	   label="#vRecord#" 
	   close="ColdFusion.Window.destroy('mydialog',true)"
	   option="#vSelectMessage#"
	   scroll="no">
	   
	<table width="100%" height="100%">
		<tr>		
			<td>
				<iframe src="#SESSION.root#/Procurement/Application/PurchaseOrder/Create/PurchaseCreate.cfm?Header=no&ActionId=#URL.actionId#&Jobno=#url.jobno#&Mission=#URL.Mission#"
			        name="right"
			        id="right"
			        width="100%"
			        height="99%"
					scrolling="no"
			        frameborder="0"></iframe>
			</td>
		</tr>
	</table>
	<cf_screenbottom layout="webapp">

</cfoutput>

