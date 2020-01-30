<cfparam name="Attributes.InstructionsText"				default="Please select some valid search criteria on the filters section.">
<cfparam name="Attributes.InstructionsIcon"				default="fa-search">

<cfoutput>
	<div class="hpanel" style="margin-top:5%">
	    <div class="panel-body text-center">
	        <i class="fa #Attributes.InstructionsIcon# text-info" style="font-size:150px;"></i>
	        <br><br><br>
	        <p style="font-size:150%;"><cf_tl id="#Attributes.InstructionsText#"></p>
			<br>
	    </div>
	</div>
</cfoutput>