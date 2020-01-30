<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>DDX report</proDes>
</cfsilent>
<!--- End Prosis template framework --->




<cfinclude template="Generation.cfm">



<cfinclude template="DdxProcessing.cfm">


<cfset output=StructNew()/>
<cfset output.Output1="Output.pdf"/>

<cfpdf name="pTOC"
	action="processddx"
	ddxfile="#reportddx#"
	inputfiles=#input#
	outputfiles=#output#>


<cfdump var="#pTOC#">
