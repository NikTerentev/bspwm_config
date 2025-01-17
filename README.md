Установка необходимых пакетов:
```bash
sudo pacman -S rofi sxhkd bspwm xorg xorg-xinit alacritty vim polybar zsh btop fastfetch ly feh flameshot telegram-desktop pcmanfm-gtk3
```

Создание директорий для конфигурационных файлов:

```bash
mkdir ~/.config
mkdir ~/.config/bspwm
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm
mkdir ~/.config/sxhkd
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd
```

Изменение дефолтного терминала в sxhkdrc:

```bspwm
super + Return
        alacritty
```

Изменение ~/.xinitrc:

```bash
exec sxhkd &
exec bspwm
```

Запуск bspwm:

```bash
startx
```

Добавление русского языка:

Открыть:

```bash
sudo vim /etc/X11/xorg.conf.d/00-keyboard.conf
```

И добавить в config:

```
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us,ru"
        Option "XkbModel" "pc105"
        Option "XkbVariant" ","
        Option "XkbOptions" "grp:win_space_toggle"
EndSection
```

Установка zsh по умолчанию:

```bash
chsh -s /bin/zsh
```

Автозапуск иксов:

```bash
vim ~/.zprofile
```

Добавить:

```
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
```

https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login

Polybar на всех мониторах:

В директории .config:

```bash
cp /etc/polybar/config.ini ~/.config/polybar/
```

Для работы polybar на всех мониторах:

в ~/.config/polybar/ добавить

launch.sh:

```bash
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  polybar --reload example &
fi
```

в самом config.ini добавить:

```bash
[bar/example]
monitor = ${env:MONITOR:}
[..]
```

в .bspwmrc в конец добавить:

```bash
$HOME/.config/polybar/launch.sh
```

Добавляем настройку мониторов:

```bash
mkdir ~/.screenlayout
echo "xrandr --output HDMI-1 --mode 1920x1080 --rate 120 --primary --output eDP-1 --mode 1920x1080 --rate 60" >> .screenlayout/display.sh
chmod +x .screenlayout/display.sh
```

В .xinitrc в начало добавляем:

```
$HOME/.screenlayout/display.sh
```

Установка login manager - ly:

```bash
sudo systemctl enable ly.service
sudo systemctl start ly.service
```

Поменяем цвета, для этого откроем файл:

```bash
sudo vim /lib/systemd/system/ly.service
```

И добавим перед ExecStart строчку:

```bash
ExecStartPre=/usr/bin/printf '%%b' '\e]P011121D\e]P7A9B1D6\ec'
```

Устанавливаем Betterlockscreen:

```bash
yay -S betterlockscreen
```

Обои помещаем в директорию ~/.config/betterlockscreen/

Устанавливаем обои:

```bash
betterlockscreen -u ~/.config/betterlockscreen/....png --dim 20
```

Добавим ручной вызов экрана блокировки в sxhkd:

```bash
super + l
      betterlockscreen -l
```

Locksreeen после сна:

```bash
# enable systemd service
systemctl enable betterlockscreen@$USER
```

Установка fehbg для обоев:

Делаем файл .fehbg в корне:

```bash
#!/bin/sh
feh --no-fehbg --bg-fill '...png'
```

и .fehbg в .xinitrc помещаем.

ОБЯЗАТЕЛЬНО ДЕЛАЕМ chmod +x для .fehbg

Устанавливаем oh-my-zsh:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Установка драйверов Nvidia:

Если в `inxi -G` их нет, то ставим:

```bash
sudo pacman -S nvidia nvidia-utils nvidia-settings nvidia-prime
```

Либо можно:

```bash
sudo pacman -S nvidia-inst
```

Установка picom:

```bash
sudo pacman -S picom 
```

Установка времени выключения экрана:

```bash
# Установка на 10 минут
xset s 600
# Просмотр статуса
xset q
```

Установка шрифтов:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

Для настройки тем устанавливаем 

```bash
sudo pacman -S lxde-appearance
```

Темы распакованные помещаем в `~/.themes`

Чтобы убрать кнопки закрытия и сворачивания и тд, нужно в firefox при редактировании панели включить галочку `title bar`, в других приложениях нужно включать `system window frame` или `system tray` и так далее.

Изменение сенсы мышки:

Показ всех устройств:

```bash
xinput list
```

Находим нужное устройство, и выставляем по его имени или айди сенсу:

```bash
xinput set-prop 'Razer Razer DeathAdder' 'libinput Accel Speed' -0.4
```

Для виджета polybar

```bash
yay -S pulseaudio-control
```