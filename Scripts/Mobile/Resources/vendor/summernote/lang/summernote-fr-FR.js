/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
(function ($) {
  $.extend($.summernote.lang, {
    'fr-FR': {
      font: {
        bold: 'Gras',
        italic: 'Italique',
        underline: 'Souligné',
        clear: 'Effacer la mise en forme',
        height: 'Interligne',
        name: 'Famille de police'
      },
      image: {
        image: 'Image',
        insert: 'Insérer une image',
        resizeFull: 'Taille originale',
        resizeHalf: 'Redimensionner à 50 %',
        resizeQuarter: 'Redimensionner à 25 %',
        floatLeft: 'Aligné à gauche',
        floatRight: 'Aligné à droite',
        floatNone: 'Pas d\'alignement',
        dragImageHere: 'Faites glisser une image avec la souris dans ce cadre',
        selectFromFiles: 'Choisir un fichier',
        url: 'URL de l\'image',
        remove: 'Supprimer l\'image'
      },
      link: {
        link: 'Lien',
        insert: 'Insérer un lien',
        unlink: 'Supprimer un lien',
        edit: 'Modifier',
        textToDisplay: 'Texte à afficher',
        url: 'URL du lien',
        openInNewWindow: 'Ouvrir dans une nouvelle fenêtre'
      },
      table: {
        table: 'Tableau'
      },
      hr: {
        insert: 'Insérer une ligne horizontale de séparation'
      },
      style: {
        style: 'Style',
        normal: 'Normal',
        blockquote: 'Citation',
        pre: 'Code source',
        h1: 'Titre 1',
        h2: 'Titre 2',
        h3: 'Titre 3',
        h4: 'Titre 4',
        h5: 'Titre 5',
        h6: 'Titre 6'
      },
      lists: {
        unordered: 'Liste à puces',
        ordered: 'Liste numérotée'
      },
      options: {
        help: 'Aide',
        fullscreen: 'Plein écran',
        codeview: 'Afficher le code HTML'
      },
      paragraph: {
        paragraph: 'Paragraphe',
        outdent: 'Diminuer le retrait',
        indent: 'Augmenter le retrait',
        left: 'Aligner à gauche',
        center: 'Centrer',
        right: 'Aligner à droite',
        justify: 'Justifier'
      },
      color: {
        recent: 'Dernière couleur sélectionnée',
        more: 'Plus de couleurs',
        background: 'Couleur de fond',
        foreground: 'Couleur de police',
        transparent: 'Transparent',
        setTransparent: 'Définir la transparence',
        reset: 'Restaurer',
        resetToDefault: 'Restaurer la couleur par défaut'
      },
      shortcut: {
        shortcuts: 'Raccourcis',
        close: 'Fermer',
        textFormatting: 'Mise en forme du texte',
        action: 'Action',
        paragraphFormatting: 'Mise en forme des paragraphes',
        documentStyle: 'Style du document'
      },
      history: {
        undo: 'Annuler la dernière action',
        redo: 'Restaurer la dernière action annulée'
      }

    }
  });
})(jQuery);
