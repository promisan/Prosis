<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------
 
Application:	Any
Project:		Any
Filename:		exec.cfm
Programmers:	Peter Coppinger <peter@digital-crew.com>
				
Purpose:		Includes the dcComponent for execution or the sets-up the parameters of the attribute

CHANGE LOG:
09 May 2002		TOP	Document Created

 ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------>

<cfsetting enablecfoutputonly="Yes">
<cfswitch expression="#ATTRIBUTES.comtype#">

	<cfcase value="component">
		<!--- Define Paths --->
		<cfinclude template="definePaths.cfm">
		<!--- Include the worker file --->
		<cftry>
			<cfinclude template= "../components/#ATTRIBUTES.component#/main.cfm">
			<cfcatch type="MissingInclude">
			<cfoutput>
			</TD></TD></TD></TH></TH></TH></TR></TR></TR></TABLE></TABLE></TABLE></A></ABBREV></ACRONYM></ADDRESS></APPLET></AU></B></BANNER></BIG></BLINK></BLOCKQUOTE></BQ></CAPTION></CENTER></CITE></CODE></COMMENT></DEL></DFN></DIR></DIV></DL></EM></FIG></FN></FONT></FORM></FRAME></FRAMESET></H1></H2></H3></H4></H5></H6></HEAD></I></INS></KBD></LISTING></MAP></MARQUEE></MENU></MULTICOL></NOBR></NOFRAMES></NOSCRIPT></NOTE></OL></P></PARAM></PERSON></PLAINTEXT></PRE></Q></S></SAMP></script></SELECT></SMALL></STRIKE></STRONG></SUB></SUP></TABLE></TD></TEXTAREA></TH></TITLE></TR></TT></U></UL></VAR></WBR></XMP>
			<h3>Component '#ATTRIBUTES.component#' Doesn't Exist!</h3>
			<p>
				Check that you have spelled the component name correctly and that<br>
				you have the component installed in the components directory.<br><br>
				Developers please note that this error may also indicate a mismatched<br>
				include from with the actual component. When developing components you<br>
				should disable this try-catch block in dcCom/engine/exec.cfm.
			</p>
			</cfoutput>
			<cfabort>
			</cfcatch>
		</cftry>
	</cfcase>
	
</cfswitch>

<!--- If this flag is set, is is an instruction from the worker file tag to SKIP processing of this tags INNER data --->
<cfif isdefined("dcCom_SkipTagContent")>
	<cfsetting enablecfoutputonly="No">
	<cfexit method="EXITTAG">
</cfif>


