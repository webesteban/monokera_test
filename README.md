
# Microservicios de Pedidos y Clientes

Este proyecto está compuesto por dos microservicios: **OrderService** y **CustomerService**. Utilizan una arquitectura **hexagonal** con `adapters` y `ports`, siguiendo principios de diseño SOLID, pruebas automatizadas y comunicación asíncrona basada en eventos con RabbitMQ.

## Requisitos

- Docker y Docker Compose instalados en tu máquina

## Ejecución

Desde la raíz del proyecto, simplemente ejecuta:

```bash
./run.sh
```

Este script construye y levanta ambos servicios junto con PostgreSQL y RabbitMQ.

## Servicios

- **OrderService**
  - Puerto: `${ORDER_SERVICE_PORT}` (ej. 3000)
  - Encargado de crear pedidos y emitir eventos `order.created`.

- **CustomerService**
  - Puerto: `${CUSTOMER_SERVICE_PORT}` (ej. 3001)
  - Escucha eventos `order.created` para actualizar el contador de pedidos del cliente.

## Arquitectura

Se sigue una **arquitectura hexagonal**, separando las preocupaciones entre la lógica de negocio y los detalles de infraestructura como RabbitMQ o Faraday. Esto permite modificar estos componentes sin afectar la lógica del dominio.

- `Adapters`: Implementaciones de puertos para mensajería o HTTP
- `Ports`: Interfaces que abstraen comportamientos externos
- `Services`: Casos de uso del dominio

## Pruebas

Ejecuta todas las pruebas con:

```bash
docker-compose exec order_service rspec
docker-compose exec customer_service rspec
```

Contamos con:

- Pruebas **unitarias** de modelos y servicios
- Pruebas de **integración** entre endpoints
- Pruebas de **eventos** para verificar la comunicación asincrónica

## Diagrama de flujo de eventos

![Diagrama de Eventos](./event_flow_diagram.png)

## Swagger

Accede a la documentación Swagger de cada servicio:

- [http://localhost:${ORDER_SERVICE_PORT}/api-docs](http://localhost:${ORDER_SERVICE_PORT}/api-docs)
- [http://localhost:${CUSTOMER_SERVICE_PORT}/api-docs](http://localhost:${CUSTOMER_SERVICE_PORT}/api-docs)
