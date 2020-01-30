<!------------------------------------------------------------------------------------------------
Component:            [Component Name]
Programmers:          [YOUR NAME] <[your email]>
Version:              [Version]
Ending Tag:           [Required/Not Required]
Styleable?:           [Yes/No]
dcCom Dependencies:   Requires dcSelectImage
Browser Specific:     Yes. MS Internet Explorer 4.5+ Only
Copyright:            Copyright (c) 2002 by Peter Coppinger, Digital Crew Ltd

Purpose:
--------------------------------------------------------------------------------------------------


Usage:
--------------------------------------------------------------------------------------------------
<CF_DCCOM component="[component name]"></CF_DCCOM>


Examples:
--------------------------------------------------------------------------------------------------
	Example 1 - [Example Name]
	<CF_DCCOM component="[component name]"></CF_DCCOM>
	

Description:	
--------------------------------------------------------------------------------------------------



CHANGE LOG:
--------------------------------------------------------------------------------------------------
[DATE]		[INITIALS]	[ACTION]

------------------------------------------------------------------------------------------------------>
<!--- IMPORTANT: In components enableCFOutputOnly="Yes" by default so theres no need to use <cfsetting enableCFOutputOnly="Yes"> --->


<!--- RECOMMENDED: Perform URL Variable Passing Security Test --->
<cfinclude template="../../engine/urlsecurity.cfm">

<!---- THIS IS SAMPLE CODE!!!! --->

<!--- Use ATTRIBUTE variables as normal e.g.  --->
<cfparam name="ATTRIBUTE.x" default="45">

<!--- SAMPLE: Code for Internet Explorer only component - delete if not required --->
<cfif NOT Find("MSIE",cgi.http_user_agent)>
	<cfoutput>
	</TD></TD></TD></TH></TH></TH></TR></TR></TR></TABLE></TABLE></TABLE></A></ABBREV></ACRONYM></ADDRESS></APPLET></AU></B></BANNER></BIG></BLINK></BLOCKQUOTE></BQ></CAPTION></CENTER></CITE></CODE></COMMENT></DEL></DFN></DIR></DIV></DL></EM></FIG></FN></FONT></FORM></FRAME></FRAMESET></H1></H2></H3></H4></H5></H6></HEAD></I></INS></KBD></LISTING></MAP></MARQUEE></MENU></MULTICOL></NOBR></NOFRAMES></NOSCRIPT></NOTE></OL></P></PARAM></PERSON></PLAINTEXT></PRE></Q></S></SAMP></script></SELECT></SMALL></STRIKE></STRONG></SUB></SUP></TABLE></TD></TEXTAREA></TH></TITLE></TR></TT></U></UL></VAR></WBR></XMP>
	<h3>#ATTRIBUTES.component# Error!</h3>
	<p><b>Sorry, only Internet Explorer 4.5+ is supported.</b></p>
	</cfoutput>
	<cfabort>
</cfif>

<CFIF ThisTag.ExecutionMode IS "Start">

	<!--- START TAG CODE --->

<CFELSEIF ThisTag.ExecutionMode IS "End">

	<!--- END TAG CODE --->

	<!--- OPTIONAL: THIS CODE RETRIEVES ALL NEST SUB TAG dcCom ATTRIBUTES into array called "assocAttribs" --->
	<!---- Sub Attribute Usage: assocAttribs[1].subAttributeName --->
	<!--- START: Extract Sub Tags --->
		<!--- Protect against no sub-tags --->
		<CFPARAM Name='thisTag.assocAttribs' default=#arrayNew(1)#>
		<!--- Loop over the attribute sets of all sub tags --->
		<CFLOOP index=i from=1 to=#arrayLen(thisTag.assocAttribs)#>
	    <!--- Get the attributes structure --->
	    <CFSET subAttribs = thisTag.assocAttribs[i]>
	</CFLOOP>
	
	<!--- END: Extract Sub Tags --->
		
	
</CFIF>