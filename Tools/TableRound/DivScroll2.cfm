<cfparam name="Attributes.id"		default="">
<cfparam name="Attributes.class"	default="">
<cfparam name="Attributes.height"	default="100%">
<cfparam name="Attributes.width"	default="100%">
<cfparam name="Attributes.hidden"	default="no">

<cfoutput>
	<style>
		body, html {
			border:0px;
			margin:0px;
			padding:0px;
		}
		
		.scrollcontainer1{
		    height: 100%;
			height: #Attributes.height#;
		    width: 100%;
			width: #Attributes.width#;
		    overflow: hidden;
			position:relative;
		}
		
		.scrollcontainer2{
		    height: 100%;
		    width: 100%;
			<cfif lcase(trim(attributes.hidden)) eq "yes" or lcase(trim(attributes.hidden)) eq "1">
			width: calc(100% + 17px);
			</cfif>
		    overflow-y: auto;
			overflow-x: hidden;
		}
	</style>
</cfoutput>

<cfif thisTag.ExecutionMode is "start">

	<div class="scrollcontainer1">
    	<div class="scrollcontainer2 #Attributes.class#" id="#attributes.id#">

<cfelse>

		</div>
	</div>

</cfif>