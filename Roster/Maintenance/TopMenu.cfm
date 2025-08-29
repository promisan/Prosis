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
<cfparam name="URL.IDRefer" default="">

<cf_menuTopHeader
  idrefer        = "#URL.IDRefer#"
  idmenu         = "#URL.IDMenu#"
  template       = "HeaderMenu1"
  systemModule   = "'Roster'"
  items          = "2"
    
  Header1        = "Reference Tables"
  FunctionClass1 = "'Maintain'"
  MenuClass1     = "'Main'"
  
  Header2        = "PHP Keywords"
  FunctionClass2 = "'Maintain'"
  MenuClass2     = "'PHP'">