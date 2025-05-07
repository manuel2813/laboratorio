# Usa la última imagen de Ruby
FROM ruby:3.2.3

# Instala dependencias necesarias
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Configura Git (opcional)
RUN git config --global user.name "Mary"
RUN git config --global user.email "marycielo.cabezas@unas.edu.pe"

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia el Gemfile y Gemfile.lock primero para instalar dependencias
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia el resto del código fuente
COPY . .
RUN bundle install
# Instala Rails (si aún no está incluido en las gemas)
RUN gem install rails -v 7.0

# Expone el puerto que usará Rails
EXPOSE 3000

# Comando para iniciar el servidor Rails
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]