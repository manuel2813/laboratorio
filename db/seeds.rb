laboratorista = User.find_by(role: :laboratorista)

if laboratorista.nil?
  puts "❌ No se encontró un usuario con rol 'laboratorista'."
  exit
end

servicios = [
  { nombre: "Calorimetría", imagen: "calorimetria.jpg" },
  { nombre: "Microscopía Óptica", imagen: "microscopia_optica.jpg" },
  { nombre: "Microscopía Electrónica", imagen: "microscopia_electronica.jpg" },
  { nombre: "Espectrofotometría UV-VIS", imagen: "uv_vis.jpg" },
  { nombre: "ICP-OES", imagen: "icp_oes.jpg" },
  { nombre: "Espectrofotometría FTIR", imagen: "ftir.jpg" },
  { nombre: "Espectrofotometría RAMAN", imagen: "raman.jpg" }
]

servicios.each_with_index do |s, i|
  servicio = Servicio.find_or_initialize_by(nombre: s[:nombre])
  servicio.imagen = s[:imagen]
  servicio.codigo_servicio = "SRV#{i + 1}"
  servicio.laboratorista = laboratorista
  if servicio.save
    puts "✅ Servicio '#{servicio.nombre}' guardado"
  else
    puts "❌ Error al guardar servicio '#{servicio.nombre}':"
    puts servicio.errors.full_messages
  end
end