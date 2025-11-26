#!/bin/bash
docker exec -i efind-db mysql -uroot -p3xQ7fuQVu7SyYCnu15Hj44U0wf0ozulOH2U3Ggt8shqZ1K27MuvC3tHqY9dyOZd6 barangay_poblacion_south < clone/eFIND/admin/barangay_poblacion_south.sql
echo "Database imported successfully!"
