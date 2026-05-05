uninstall_theme() {
  echo " "
  echo -e "  ${BRIGHT_CYAN}${BOLD}┌────────────────────────────────────────────────────────────────────────┐${NC}"
  echo -e "  ${BRIGHT_CYAN}${BOLD}│${NC}  ${WHITE}${BOLD}RESET PANEL (UNINSTALL THEME/TOOLS)${NC}"
  echo -e "  ${BRIGHT_CYAN}${BOLD}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo " "

  if [ ! -d "/var/www/pterodactyl" ]; then
    print_error "Direktori Pterodactyl tidak ditemukan."
    return 1
  fi
  cd /var/www/pterodactyl || { print_error "Gagal masuk ke direktori Pterodactyl."; return 1; }

  print_info "⚙️  Memulai proses reset panel..."

  echo -e "${BOLD}   - Mem-backup file .env...${NC}"
  TEMP_BACKUP=$(mktemp -d)
  if [ -f ".env" ]; then sudo mv .env "$TEMP_BACKUP/"; fi

  echo -e "${BOLD}   - Menghapus semua file panel lama...${NC}"
  sudo find . -mindepth 1 -delete
  
  echo -e "${BOLD}   - Mengunduh panel original terbaru...${NC}"
  curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | sudo tar -xzf - -C /var/www/pterodactyl

  echo -e "${BOLD}   - Mengembalikan file .env...${NC}"
  if [ -f "$TEMP_BACKUP/.env" ]; then sudo mv "$TEMP_BACKUP/.env" .; fi
  rm -rf "$TEMP_BACKUP"

  echo -e "${BOLD}   - Install ulang dependensi (Composer)...${NC}"
  sudo chmod -R 755 storage/* bootstrap/cache/
  sudo chown -R www-data:www-data /var/www/pterodactyl
  curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
  sudo rm -rf /var/www/.cache
  sudo mkdir -p /var/www/.cache
  sudo chown -R www-data:www-data /var/www/.cache
  sudo -u www-data env COMPOSER_PROCESS_TIMEOUT=2000 composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist > /dev/null 2>&1

  echo -e "${BOLD}   - Menjalankan migrasi...${NC}"
  sudo -u www-data php artisan migrate --seed --force

  echo -e "${BOLD}   - Membersihkan cache sistem...${NC}"
  sudo -u www-data php artisan optimize:clear
  sudo -u www-data php artisan view:clear
  sudo -u www-data php artisan config:clear
  sudo -u www-data php artisan route:clear
  sudo -u www-data php artisan cache:clear
  sudo rm -f /usr/local/bin/blueprint

  echo -e "${BOLD}   - Restart layanan webserver & worker...${NC}"
  sudo systemctl restart nginx > /dev/null 2>&1 || sudo systemctl restart apache2 > /dev/null 2>&1
  sudo systemctl restart "php*-fpm" > /dev/null 2>&1 || true
  sudo systemctl restart pteroq
  sudo -u www-data php artisan up

  echo " "
  echo -e "  ${BRIGHT_GREEN}${BOLD}╔══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "  ${BRIGHT_GREEN}${BOLD}║${NC}  ${WHITE}${BOLD}👑 PANEL HAS BEEN SUCCESSFULLY RESET${NC}"
  echo -e "  ${BRIGHT_GREEN}${BOLD}╚══════════════════════════════════════════════════════════════════════╝${NC}"
  echo " "
  sleep 3
  return 0
}
