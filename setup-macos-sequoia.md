# macOS Sequoiaをクリーンインストールする方法



ディスクユーティリティを起動して、Uaveilableリックして消去します  
名前に```SetupSequoia```(任意)と入力しフォーマットは```Mac OS拡張(ジャーナリング)```を選択します

ターミナルから下記のコマンドを入力します
```
sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia --volume /Volumes/SetupSequoia
```

```
~ % sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia --volume /Volumes/SetupSequoia
Password:
Ready to start.
To continue we need to erase the volume at /Volumes/SetupSequoia.
If you wish to continue type (Y) then press return: y
Erasing disk: 0%... 10%... 20%... 30%... 100%
Copying essential files...
Copying the macOS RecoveryOS...
Making disk bootable...
Copying to disk: 0%... 10%... 20%... 30%... 40%... 50%... 60%... 70%... 80%... 90%... 100%
Install media now available at "/Volumes/Install macOS Sequoia"
```

```Install media now aveilable at ...```と表示されたらUSBインストーラーの完成です

