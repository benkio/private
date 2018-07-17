;; Contains my custom funcitons functions. Loaded after
;; layers.el
;; packages.el

(defun xml-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "xmllint --format -" (buffer-name) t)
    )
  )

(defun copy-file-name-to-clipboard (filename-manipulate-func)
  "Copy the current buffer file name to the clipboard after the application of the input function."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (let ((changedFilename (funcall filename-manipulate-func filename)))
        (when changedFilename
          (kill-new changedFilename)
          (message "Copied buffer file name '%s' to the clipboard." changedFilename))))))

(defun copy-file-name-and-path-to-clipboard ()
  "Copy the current buffer file name and path to clipboard."
  (interactive)
  (copy-file-name-to-clipboard 'identity))

(defun copy-just-file-name-to-clipboard ()
  "Copy just the current buffer file name to clipboard."
  (interactive)
  (copy-file-name-to-clipboard 'file-name-nondirectory))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "S-M-l") 'shrink-window-horizontally)
(global-set-key (kbd "S-M-r") 'enlarge-window-horizontally)
(global-set-key (kbd "S-M-d") 'shrink-window)
(global-set-key (kbd "S-M-u") 'enlarge-window)

(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun set-80-columns ()
  "Set the selected window to 80 columns."
  (interactive)
  (set-window-width 80))

(defun neotree-resize-window (&rest _args)
  "Resize neotree window .
https://github           . com/jaypei/emacs-neotree/pull/110"
  (interactive)
  (neo-buffer--with-resizable-window
   (let ((fit-window-to-buffer-horizontally t))
     (fit-window-to-buffer))))

(defun reverse-words (beg end)
  "Reverse the order of words in region . "
  (interactive "*r")
  (apply
   'insert
   (reverse
    (split-string
     (delete-and-extract-region beg end) "\\b"))))

(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting . "
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))

(defun indent-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))