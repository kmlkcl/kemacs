
(defun kml-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(defun kml-line-down ()
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(defun kml-window-width (n)
  "Width multiplier N for current window."
  (interactive "nEnter width increment: ")
  (enlarge-window-horizontally n))

(defun kml-ffmpeg-convert-screencast-async (basename)
  "Asynchronously convert ~/Videos/Screencasts/BASENAME.webm to BASENAME.mp4 using ffmpeg.
Shows a message when conversion finishes."
  (interactive "sEnter base filename (without extension): ")
  (let* ((dir (expand-file-name "~/Videos/Screencasts/"))
         (input-file (concat dir basename ".webm"))
         (output-file (concat dir basename ".mp4"))

         (cmd (list "ffmpeg"
                    "-i" input-file
                    "-vf" "scale=trunc(iw/2)*2:trunc(ih/2)*2"
                    "-c:v" "libx264"
                    "-c:a" "aac"
                    output-file))
         (buffer-name "*ffmpeg-conversion*"))
    (if (file-exists-p input-file)
        (let ((proc (make-process
                     :name "ffmpeg-process"
                     :buffer (get-buffer-create buffer-name)
                     :command cmd
                     :noquery t
                     :sentinel
                     (lambda (process event)
                       (when (string= event "finished\n")
                         (message "Conversion of %s finished!" basename)
                         (kill-buffer buffer-name))))))
          ;; Don't show the buffer
          (with-current-buffer buffer-name
            (setq-local buffer-read-only t))
          (message "Started conversion of %s..." basename))
      (message "Input file does not exist: %s" input-file))))


(defun kml-cmake-debug-build ()
  "Run CMake with advanced options for debug build using Ninja in the current project.
Asks to delete the 'build' directory if it exists, then recreates and builds it."
  (interactive)
  (let* ((proj (project-current))
         (root (if proj
                   (directory-file-name (expand-file-name (project-root proj)))
                 (user-error "No project detected")))
         (build-dir (expand-file-name "build" root))
         (cmake-cmd (format
                     "cmake -DCMAKE_BUILD_TYPE:STRING=Debug \
-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE \
-DCMAKE_C_COMPILER:FILEPATH=/usr/bin/gcc \
-DCMAKE_CXX_COMPILER:FILEPATH=/usr/bin/g++ \
--no-warn-unused-cli \
-S%s \
-B%s \
-G Ninja"
                     root build-dir))
         (full-cmd (format "%s && ninja -C %s" cmake-cmd build-dir)))
    ;; Ask before deleting build directory
    (when (and (file-directory-p build-dir)
               (yes-or-no-p (format "Delete existing build directory at %s? " build-dir)))
      (delete-directory build-dir t))

    ;; Ensure build directory exists
    (unless (file-directory-p build-dir)
      (make-directory build-dir))

    ;; Run cmake and ninja in sequence
    (async-shell-command full-cmd "*cmake-output*")))

(defun kml-run-debug ()
  "Run the 'debug' executable inside the 'build' directory of the current project."
  (interactive)
  (let* ((proj (project-current))
         (root (if proj
                   (project-root proj)
                 (user-error "No project found")))
         (build-dir (expand-file-name "build" root))
         (exe-path (expand-file-name "Debug/kemware" build-dir)))
    (unless (file-executable-p exe-path)
      (user-error "Executable not found: %s" exe-path))
    (let ((default-directory build-dir))
      (async-shell-command "./Debug/kemware" "*debug-run*"))))

(defun kml-config ()
  "Opens .emacs config file."
  (interactive)
  (find-file (expand-file-name "~/.emacs")))

(defun kml-home ()
  "Opens kemacs.org"
  (interactive)
  (find-file (expand-file-name "~/kemacs.org")))

(defun kml-todos ()
  "Opens TODOs"
  (interactive)
  (find-file (expand-file-name "~/kems-todos.org")))

(defun kml-emacs-update-config ()
  "Updates the emacs config from kemware project copy"
  (interactive)
  (setq copy_command "cp ~/kemware/.emacs ~/.emacs")
  (async-shell-command copy_command))

(defun kml-header-create (filename macro-name)
  "Create a header file named FILENAME in ~/kemware/inc with include guards using MACRO-NAME."
  (interactive
   (list
    (read-string "Header file name (e.g., kw_colorPalette.h): ")
    (read-string "Include guard macro name (e.g., KW_COLOR_PALETTE_H): ")))
  (let* ((dir "~/kemware/inc/")
         (full-path (expand-file-name filename dir)))
    ;; Create the directory if it doesn't exist
    (unless (file-directory-p dir)
      (make-directory dir t))
    ;; Create and write to the file
    (with-temp-file full-path
      (insert (format "#ifndef %s\n#define %s\n\n#include \"kw_types.h\"\n\n#endif // %s\n"
                      macro-name macro-name macro-name)))
    ;; Open the newly created file
    (find-file full-path)
    (message "Header file created and opened at %s" full-path)))



(defun camel-to-pascal (str)
  "Convert a camelCase STR to PascalCase."
  (concat (capitalize (substring str 0 1)) (substring str 1)))


(defun kml-macro-create-function-2 (rType pType1 pName1 pType2 pName2)
  "Creates a create method as usual with given parameters."
  (interactive
   (list
    
    (read-string "Return Type without pointer: ")
    (read-string "Parameter Type 1, use pointer if necessary: ")
    (read-string "Parameter name, camelCase: ")
    (read-string "Parameter Type 2, use pointer if necessary: ")
    (read-string "Parameter name 2, camelCase: ")
    ))

  (insert "extern " rType " *" rType "_Create(")
  (insert pType1 " " pName1)
  (insert ", " pType2 " " pName2)
  (insert ")\n{\n")
  (insert "    " rType " *newItem = KW_Memory_MallocSafe(sizeof *newItem);\n")
  (insert "    newItem->" (camel-to-pascal pName1) " = " pName1 ";\n")
  (insert "    newItem->" (camel-to-pascal pName2) " = " pName2 ";\n")
  (insert " \n// ADD YOUR CUSTOM STUFF HERE...\n ")
  (insert " \n   return newItem;\n")
  (insert "}\n"))



(defun kml-macro-create-function-3 (rType pType1 pName1 pType2 pName2 pType3 pName3)
  "Creates a create method as usual with given parameters."
  (interactive
   (list
    
    (read-string "Return Type without pointer: ")
    (read-string "Parameter Type 1, use pointer if necessary: ")
    (read-string "Parameter name, camelCase: ")
    (read-string "Parameter Type 2, use pointer if necessary: ")
    (read-string "Parameter name 2, camelCase: ")
    (read-string "Parameter Type 3, use pointer if necessary: ")
    (read-string "Parameter name 3, camelCase: ")
    ))

  (insert "extern " rType " *" rType "_Create(")
  (insert pType1 " " pName1)
  (insert ", " pType2 " " pName2)
  (insert ", " pType3 " " pName3)
  (insert ")\n{\n")
  (insert "    " rType " *newItem = KW_Memory_MallocSafe(sizeof *newItem);\n")
  (insert "    newItem->" (camel-to-pascal pName1) " = " pName1 ";\n")
  (insert "    newItem->" (camel-to-pascal pName2) " = " pName2 ";\n")
  (insert "    newItem->" (camel-to-pascal pName3) " = " pName3 ";\n")
  (insert " \n// ADD YOUR CUSTOM STUFF HERE...\n ")
  (insert " \n   return newItem;\n")
  (insert "}\n"))

(defun kml-macro-create-function-4 (rType pType1 pName1 pType2 pName2 pType3 pName3 pType4 pName4)
  "Creates a create method as usual with given parameters."
  (interactive
   (list
    
    (read-string "Return Type without pointer: ")
    (read-string "Parameter Type 1, use pointer if necessary: ")
    (read-string "Parameter name, camelCase: ")
    (read-string "Parameter Type 2, use pointer if necessary: ")
    (read-string "Parameter name 2, camelCase: ")
    (read-string "Parameter Type 3, use pointer if necessary: ")
    (read-string "Parameter name 3, camelCase: ")
    (read-string "Parameter Type 4, use pointer if necessary: ")
    (read-string "Parameter name 4, camelCase: ")
    ))

  (insert "extern " rType " *" rType "_Create(")
  (insert pType1 " " pName1)
  (insert ", " pType2 " " pName2)
  (insert ", " pType3 " " pName3)
  (insert ", " pType4 " " pName4)
  (insert ")\n{\n")
  (insert "    " rType " *newItem = KW_Memory_MallocSafe(sizeof *newItem);\n")
  (insert "    newItem->" (camel-to-pascal pName1) " = " pName1 ";\n")
  (insert "    newItem->" (camel-to-pascal pName2) " = " pName2 ";\n")
  (insert "    newItem->" (camel-to-pascal pName3) " = " pName3 ";\n")
  (insert "    newItem->" (camel-to-pascal pName4) " = " pName4 ";\n")
  (insert " \n// ADD YOUR CUSTOM STUFF HERE...\n ")
  (insert " \n   return newItem;\n")
  (insert "}\n"))


(defun kml-macro-create-function-6 (rType pType1 pName1 pType2 pName2 pType3 pName3 pType4 pName4 pType5 pName5 pType6 pName6)
  "Creates a create method as usual with given parameters."
  (interactive
   (list
    
    (read-string "Return Type without pointer: ")
    (read-string "Parameter Type 1, use pointer if necessary: ")
    (read-string "Parameter name, camelCase: ")
    (read-string "Parameter Type 2, use pointer if necessary: ")
    (read-string "Parameter name 2, camelCase: ")
    (read-string "Parameter Type 3, use pointer if necessary: ")
    (read-string "Parameter name 3, camelCase: ")
    (read-string "Parameter Type 4, use pointer if necessary: ")
    (read-string "Parameter name 4, camelCase: ")
    (read-string "Parameter Type 5, use pointer if necessary: ")
    (read-string "Parameter name 5, camelCase: ")
    (read-string "Parameter Type 6, use pointer if necessary: ")
    (read-string "Parameter name 6, camelCase: ")
    ))

  (insert "extern " rType " *" rType "_Create(")
  (insert pType1 " " pName1)
  (insert ", " pType2 " " pName2)
  (insert ", " pType3 " " pName3)
  (insert ", " pType4 " " pName4)
  (insert ", " pType5 " " pName5)
  (insert ", " pType6 " " pName6)
  (insert ")\n{\n")
  (insert "    " rType " *newItem = KW_Memory_MallocSafe(sizeof *newItem);\n")
  (insert "    newItem->" (camel-to-pascal pName1) " = " pName1 ";\n")
  (insert "    newItem->" (camel-to-pascal pName2) " = " pName2 ";\n")
  (insert "    newItem->" (camel-to-pascal pName3) " = " pName3 ";\n")
  (insert "    newItem->" (camel-to-pascal pName4) " = " pName4 ";\n")
  (insert "    newItem->" (camel-to-pascal pName5) " = " pName5 ";\n")
  (insert "    newItem->" (camel-to-pascal pName6) " = " pName6 ";\n")
  (insert " \n// ADD YOUR CUSTOM STUFF HERE...\n ")
  (insert " \n   return newItem;\n")
  (insert "}\n"))


