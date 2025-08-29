<!--
    Copyright © 2025 Promisan B.V.

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
<!----

urlsecurity.cfm

Purpose: To Ensure that a component is being accessed by another
cold fusion template and NOT via URL request.

Programmed by Peter Coppinger June 10 2002.
Note: I Rang Keith at 1.50am to discuss dcCom security and he
was very helpful. Many Thanks Keith.


--->
<cfif NOT isdefined("ATTRIBUTES.component") OR isdefined("URL.ATTRIBUTES.component") OR isdefined("FORM.ATTRIBUTES.component")>
	<cfoutput>
		</TD></TD></TD></TH></TH></TH></TR></TR></TR></TABLE></TABLE></TABLE></A></ABBREV></ACRONYM></ADDRESS></APPLET></AU></B></BANNER></BIG></BLINK></BLOCKQUOTE></BQ></CAPTION></CENTER></CITE></CODE></COMMENT></DEL></DFN></DIR></DIV></DL></EM></FIG></FN></FONT></FORM></FRAME></FRAMESET></H1></H2></H3></H4></H5></H6></HEAD></I></INS></KBD></LISTING></MAP></MARQUEE></MENU></MULTICOL></NOBR></NOFRAMES></NOSCRIPT></NOTE></OL></P></PARAM></PERSON></PLAINTEXT></PRE></Q></S></SAMP></script></SELECT></SMALL></STRIKE></STRONG></SUB></SUP></TABLE></TD></TEXTAREA></TH></TITLE></TR></TT></U></UL></VAR></WBR></XMP>
		<b>dcCom SECURIITY BREECH</b><br>
		Accessing dcCom components via URL/FORM method is not allowed.
	</cfoutput>
	<cfabort>
</cfif>