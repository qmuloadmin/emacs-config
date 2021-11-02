;; General setup of high level deps, paths, tabs, etc
(setq default-directory "/home/zach/Projects/src/github.com/OrderMyGear/")
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq x-select-enable-clipboard t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq-default truncate-lines t)
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))
(load "~/.emacs.d/sql-config.el")
(setq make-backup-files nil) ;; Disable obnoxious backup files. 
(setq-default tab-width 4)
(desktop-save-mode 1)
(electric-pair-mode)
(global-tab-line-mode) ;; Enable buffer tabs in each window
(tool-bar-mode -1)
(menu-bar-mode -1)

;; hs-mode (for code hiding/showing blocks)
(global-set-key (kbd "<M-up>") 'hs-hide-block)
(global-set-key (kbd "<M-down>") 'hs-show-block)

;; Goto line (based on evil :)
(global-set-key (kbd "C-:") 'goto-line)

;; Helm search

(use-package helm
  :ensure t
  )

;; SQL Mode

(eval-after-load 'sql
  '(define-key sql-mode-map (kbd "<C-return>") 'sql-send-paragraph))
(eval-after-load 'sql
  '(define-key sql-mode-map (kbd "<M-return>") 'sql-send-region))

(defun buffer-to-sql-and-sqli ()
  (interactive)
  (sql-mode)
  (sql-set-sqli-buffer-generally)
)

(define-key global-map (kbd "C-c S") 'buffer-to-sql-and-sqli)

;; Magit
(unless (package-installed-p 'magit)
  (package-refresh-contents)
  (package-install 'magit))

(define-key global-map (kbd "C-c g") 'magit-status)

;; Org Mode
(use-package org
  :ensure t
  :hook
  ((org-mode . company))
  )
(require 'org)

;; HTTP Client For Org Mode
(use-package restclient
  :ensure t
  )

;; Sidebar Configuration

(unless (package-installed-p 's)
  (package-refresh-contents)
  (package-install 's))
(unless (package-installed-p 'dash)
  (package-refresh-contents)
  (package-install 'dash))
(unless (package-installed-p 'dash-functional)
  (package-refresh-contents)
  (package-install 'dash-functional))
(unless (package-installed-p 'ov)
  (package-refresh-contents)
  (package-install 'ov))
(unless (package-installed-p 'frame-local)
  (package-refresh-contents)
  (package-install 'frame-local))
(unless (package-installed-p 'projectile)
  (package-refresh-contents)
  (package-install 'projectile))
(add-to-list 'load-path "~/.emacs.d/libs")
(require 'font-lock+)
(require 'move-border)
(add-to-list 'load-path "~/.local/share/icons-in-terminal/")
(add-to-list 'load-path "~/Projects/src/github.com/sebastiencs/sidebar.el")
(require 'sidebar)
(global-set-key (kbd "C-x C-f") 'sidebar-open)
(global-set-key (kbd "C-x C-a") 'sidebar-buffers-open)
(defun sidebar-go-home-omg ()
  (interactive)
  (sidebar-open-directory (sidebar-file-struct "~/Projects/src/github.com/OrderMyGear"))
)
(global-set-key (kbd "C-c C-o") 'sidebar-go-home-omg)

;; Quick yaml config
(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  )

;; LSP-Mode optional deps
(unless (package-installed-p 'flycheck)
  (package-install 'flycheck))

;; Rust DE Configuration
;; Also, PHP, Go, Bash is buried in here, a hook about php-mode

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (setq rustic-lsp-client 'lsp-mode
        rustic-lsp-server 'rust-analyzer
        rustic-analyzer-command '("~/.cargo/bin/rust-analyzer"))
  (define-key rustic-mode-map (kbd "C-c R") 'rustic-cargo-run)
  (define-key rustic-mode-map (kbd "C-c T") 'rustic-cargo-test)
  (define-key rustic-mode-map (kbd "C-c F") 'rustic-cargo-fmt)
  (add-hook 'rustic-mode-hook #'company-mode)
)

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(use-package lsp-mode
  :ensure t
  :hook
  ((go-mode . lsp))
  ((php-mode . lsp))
  ((sh-mode . lsp))
  ((python-mode . lsp))
  ((web-mode . lsp))
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook 'hs-minor-mode)
)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show nil)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable t)
  )

;; Random Custom stuff

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-matching-paren t)
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(horizontal-scroll-bar-mode nil)
 '(lsp-file-watch-threshold 4000)
 '(lsp-ui-doc-position 'at-point)
 '(lsp-ui-flycheck-list-position 'right)
 '(mouse-wheel-flip-direction t)
 '(mouse-wheel-tilt-scroll t)
 '(org-babel-load-languages
   '((emacs-lisp . t)
	 (python . t)
	 (shell . t)
	 (js . t)
	 (sql . t)))
 '(org-src-window-setup 'current-window)
 '(package-selected-packages
   '(helm yaml-mode yaml prettier-js clojure-mode flycheck company company-mode go-autocomplete go-complete go-mode auto-complete auth-complete lsp-ui lsp-mode rustic use-package s quelpa projectile ov frame-local dash-functional))
 '(scroll-bar-mode nil)
 '(sidebar-adjust-auto-window-width nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tab-line-tab ((t (:inherit tab-line :background "gray" :foreground "black" :box (:line-width 2 :color "gray") :weight semi-bold :height 80 :width ultra-condensed))))
 '(tab-line-tab-inactive ((t (:inherit tab-line-tab :background "gray17" :foreground "white smoke" :box (:line-width 2 :color "gray17") :weight semi-bold)))))

;; Window resizing configuration

(global-set-key (kbd "M-S-<up>") 'move-border-up)
(global-set-key (kbd "M-S-<down>") 'move-border-down)
(global-set-key (kbd "M-S-<left>") 'move-border-left)
(global-set-key (kbd "M-S-<right>") 'move-border-right)

;; Window movement configuration

(global-set-key (kbd "C-S-<left>") 'windmove-left)
(global-set-key (kbd "C-S-<right>") 'windmove-right)
(global-set-key (kbd "C-S-<up>") 'windmove-up)
(global-set-key (kbd "C-S-<down>") 'windmove-down)

;; More consistent Copy/Cut/Paste with "non emacs" bindings and mouse region selection

(global-set-key (kbd "C-S-c") 'kill-ring-save)
(global-set-key (kbd "C-S-x") 'kill-region)
(global-set-key (kbd "C-S-v") 'yank)

;; LSP Keybinds

(global-set-key (kbd "S-M-r") 'lsp-rename)

;; Update this path to match whatever path intelephense was installed in
(add-to-list 'exec-path "~/.nvm/versions/node/v10.20.1/bin/")
(add-to-list 'exec-path "~/bin/")

;; Go DE Configuration

(unless (package-installed-p 'company)
  (package-refresh-contents)
  (package-install 'company))

;; Just to make sure go tools are enabled
(add-to-list 'exec-path "~/go/bin")

;; Go - lsp-mode

(defun go-before-save ()
  (interactive)
  (when lsp-mode
    (lsp-organize-imports)
    (lsp-format-buffer)))

(use-package go-mode
  :defer t
  :ensure t
  :config
  (add-hook 'go-mode-hook 'lsp-deferred)
  (add-hook 'go-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'go-before-save))))

;; DAP (standard protocol for remote debugging servers) Configuration

;;(use-package dap-mode
;;  :ensure t
;; )

;;(dap-register-debug-provider
;; "go"
;; (lambda (conf)
;;   (plist-put conf :debugPort 3334)
;;   (plist-put conf :host "localhost")
;;   conf))

;; Markdown support

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "markdown-it")
  :config (add-hook 'markdown-mode
				  (lambda ()
					   (make-local-variable 'truncate-lines)
					   (setq truncate-lines nil))))

;; JS Stuff

;; Prettier
(use-package prettier-js
  :ensure t
  )

;; Webmode for TSX highlighting (works with LSP)
(use-package web-mode  :ensure t
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
		 ("\\.json\\'" . web-mode))
  :hook
  ((web-mode . prettier-js-mode))
  :commands web-mode
  :config
  (setq web-mode-content-types-alist
	'(("jsx" . "\\.js[x]?\\'")))
)


;; Custom Window Layout at start
;; layout definition
(defun startup-layout ()
 (interactive)
 (delete-other-windows)
 (sidebar-open)
 (next-multiframe-window) ;; Move out of sidebar window
 (split-window-vertically) ;; -> --
 (split-window-horizontally) ;;  -> |
 (next-multiframe-window) ;; Move to Right Window
 (next-multiframe-window) ;; Move to Bottom Window
 (shrink-window 25) ;; Shrink to a couple lines of text
 (term "/bin/bash") ;; Start shell
 (set-window-dedicated-p (get-buffer-window) t) ;; Make the terminal invalid for other buffers
 (previous-multiframe-window) ;; Go back to Right Window
 (shrink-window-horizontally 20)
 (split-window-vertically) ;; -> --  so we have 1 left and 2 right, and a terminal below
 (previous-multiframe-window) ;; back to Left Window
)

;; execute the layout
(startup-layout)
(sidebar-toggle-hidden-files) ; disable hidden files by default (press h to enable)

;; Themes

(unless (package-installed-p 'zenburn-theme)
  (package-install 'zenburn-theme))
(unless (package-installed-p 'spacemacs-theme)
  (package-install 'spacemacs-theme))
(load-theme 'spacemacs-dark)

(defun toggle-theme ()
  (interactive)
  (if (eq (car custom-enabled-themes) 'spacemacs-dark)
      (progn 
       (disable-theme 'spacemacs-dark)
       (enable-theme 'spacemacs)
      )
    (progn
     (disable-theme 'spacemacs)
     (enable-theme 'spacemacs-dark)
    ))
)

(global-set-key (kbd "C-S-t") 'toggle-theme)
(sidebar-go-home-omg)
