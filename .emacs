;; -*- lexical-binding: t; -*-

(global-display-line-numbers-mode)
(split-window-horizontally)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))


(setq initial-buffer-choice "~/kemacs.org")

(load-theme 'kheme-2 t)  ;; initial load
(add-hook 'after-init-hook
          (lambda ()
            (load-theme 'kheme-2 t)))




(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'clang-format)
(global-set-key (kbd "C-c C-f") 'clang-format-buffer)

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'org-mode-hook #'visual-line-mode)

(require 'lsp)
(require 'lsp-mode)
(setq lsp-semantic-tokens-enable t)

(add-hook 'c-mode-hook #'lsp)
(add-hook 'csharp-mode #'lsp)

(with-eval-after-load 'lsp-mode
  ;; :global/:workspace/:file
  (setq lsp-modeline-diagnostics-scope :workspace))

(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "<S-f12>") #'lsp-find-references))

(setq lsp-clients-clangd-args
      '("--header-insertion=never"))


(global-company-mode 1)



(add-to-list 'load-path "~/.emacs.d/lisp") ;; or wherever the file is
(load "kml-functions")

(global-set-key (kbd "C-M-p") 'kml-line-up)
(global-set-key (kbd "C-M-n") 'kml-line-down)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d4b07043b9d34b09a44767fbf8f36b2a68736f6e44a0065902f689ae49783a23" "d49550d65cff881627be2ad5f97c3eaf263845ad6600adf6ab8a4f8a98ff7f59" "0316cb02f9d7b0b053aced505d04b49cb2715aabf9d94fa8c5f2d579e03c901a" "da46f4f4f084ca69bf1e937155544e768e5cdf5cfee284102792d89b7bfabdb0" "f54ad6e07f20fd314f536b2760177dfedff4eefc58afdbc870a2ec8da92769a4" "fde838b5510adca40325013b1524cc2f84cecd306c54d1f4dcb90dd657ec19da" "6c2dd4f77ea6b346478dc364ecef9c2c2bfb00abe47f2d6ddc044dcad7c855a6" "eed4cda00e1f62af1459cc815d63d23380eb21aee5f7eabd401dcfaed9d1c11d" "e2f8db22592e140dced3ad18d1c7be5b67daba7d04b5fedaf5a043ef849896da" "63fc78552683aaddf0d650a05a967bb61259ce8e205a8aaa58f00516325ddd49" "51b582f2106885baaf982fd6a726fc7c81a969bff24c24a68fa6d19dd2e6c523" "49276f230de9c4bdb059e4c780d9da27c4f042d72b32b75ba2b45336767dec0c" "0c21242d08e06600c391f949a13d2939ce5a80705e9b5d9f2bc7a1476683ca9c" "a19c23042ca35fd80faec9ecf7e4853be7a7f552216bc51c107899d518061cd8" "e7d8ff53b5661821651329ffea5e0d60b309d070b17cc71b95f3ba5a13fc85de" "b6d1cd823aabd6e618f2c186866a6338f5774b8cce164a7b213b5308de913387" "39eb0d77bc6f7f2aac47c901cb1b8ec417ba49e4f28b99fbb33b611fde56260b" "cd7718033700fc9e9b75f185e907aed1763cf9df57f2523ed6b7264e1c10f059" "deb313794886ac06bbd6ca8111317148d596f4056f783ab59153260e2ee1fb81" "12f272f9951686537b64265e04f7ea20479439539e5841d6815e8b7e9c6ea1b3" "b376a9c64ef2c5e230220a26b2497858ab279e39127e6315d0fb59feabc223b3" "0dab3082610baf6f51a90805a3f1eb1286e041033d4579f485099487737c9561" "8c357a5432a552b90a586a96cf24a72d647bbbe81e56f382d114e4b42ec85d4f" "0679d7af8bde509a94ce62322ccf16b0058bceb553b07a079ed4490230a7cfbe" "65c46ee77857d87cdaf621fd0d6e6bb648479671f326d5170a3305a2d6568317" "6628f7f6caff4ca68f6e127b4da0c6c800f62cb4271131f2631309f5226e55ad" "32c470707bf461964ce9859ef63a9cd45050097b26449907cf96801207fee958" "e42c66a2173a4a0e361c6c313ececd6e8745444d667d851af6dbc81badd4049d" "99362181a2021204b3f14f43f69c740a5152011c0318f778508193f80083d3db" "05787443a830a7ecd27e3a6e591f70892662298e1bbac9f4bf214e1be96952f8" "0367fd355c34ff28a74bf5e3ad8735248d194311d83d3f82958640a9739b65aa" "0b904356a4639aa1fd64e5c31ba0712e133e21a8fc2459e9c2c36eedc94bd366" "6a91adf3dc77e052ba8e64b6aca006f80a392494dce4995d8b6dd38cf6e4cd81" "da1459842329ad8ad64cba8184661dc00d5baa2ebd5ee44f23e16e1abd69e97e" "5436a40aad40d64d3cf6b8c5c1bb1da62b8fcaa3d60f73673a5ca7ea1437500c" "d39788413372fd23624f36b5d762d3a59a679d142dea49379fd2ca6b16c2a5dc" "f9f5809980bec3be530dc504940879a924e6d0a41ab5d4a8ad634523775532b4" "81093422e2722f1ebdb385ccbc71be1198caf5f3d5ec8fc03e34d60c496e4056" "a5d18ce30681d5e0ebd75f82893d8cc6719f77d40a3ba05372e40e9932b4566a" "1f1357c866aaa09ee89da4eae2bef515251e86b604e5c95d71f6188100bd46b8" "9b3722b566ca297dfecc3cea9c68a0bf018b3e603a5aa44d76785feb162c701f" "4fa98fd2771f3c354b9deea3554c02a10d0bd783dfadbd815d208e2cf3ab1808" "2d17c5d066a6b3b4f00f17a01ffdbfdb09c98474559430567a95fcc063fa47a5" "6105a814892437d24dd44f1bdd89e3789f2286ae0fd09cc315621c9d2cb55fe8" "2723c08ed317b79c18b5d1bd18732f0743fddc7d093a764e99da78157de88519" "70e0f500320fb9af37f5a932ef7b6eb72b213c31b1f228308674b2acad2d1c63" "c58b187367f67ad56d86a7907f25deedf7a8774e411c593f6ede71153aa6babd" "45ad9e8dddd60d8fec274cc2e5d86e07ccc6f5cc3e3cf77cbdb0b6e3add4a8e0" "06b97e76cca219c2c498fcbb5e5123c8129515a16baeb5c11c1607bf8c51c55b" "3743c92f9caaf7511e38f2f51ade820e9c5f41cc5440378c2dd8a7cdba956b97" "2c4b4b99960ac708df006f76a8e0052391cdcfd3c05bd7f38c9da6e2211fb919" "7fed89a371473137cddab0f99d30923ce3d402513cfd3c288357991ed389b9ca" "0b7a26e8058f9586fd3a1b472352f428b5c2de5b5335d48c46149b0fe7b30894" "828579a32e9cfb9239fb1e5e6132e0b27a05474d4a1fa9c464cbfa642a6567a5" "96e7d7852ad13a3a9a21c1be0654e4150942d131f88485c81554382955f8de25" "65b3bcec864f8caeb4b97ca8159de87453590a6c846005d1da0f2588a3946ef7" "f41a915d1eff73db041b9bb00865f377f763afba9610bcf5b3139ccb598f9772" "161717466b509a2d923b256b11bb2f5d527a7f987bb0a3a8840c67fd6d471ced" "6e654e25c61a917f32f32cd4aca5148967cda12e7faa184536b4c58ece1cf864" "30e6f9666257e6c53782b81fd2f360ae00e038293b301e5fbe7e95e6a18e918b" "701df90698064b41541cfa6ec26688dab2ea95b61fc664985fed7e7a5afd6ed5" "c8a2f4643865ddbdaa21f21c7493f81492e5ef6eb50969a6c32f0458f336bee5" "5beeab7d53050fae98fc9022734d1aaf3c09c0ee5409c1aab55fcb200a7027e0" "01215eabd89ab4af495c4512b1724fb76bb599f81f008afc5f813c5dba96005b" "a59846165c9bb680f21d201f86bf94f2f55d8b6cd60f3ec9429b75769676c7b8" "11fb94bb6f79f32894c10a867256920e89ff0fe57de859a9e6726598ff23ce07" "e5bc154e25dfc6d461ac70f73bb8360920e85bda9bda31bda5dc32514c50d6ad" "7fc610c94353dfdf206508f73a41658dd180a646f0f859b84945c2489d4186b1" default))
 '(package-selected-packages '(magit lsp-ui flycheck doom-themes company clang-format)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
