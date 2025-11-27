import { RowDataPacket } from 'mysql2';
import pool from '../../../config/database';

export class OficinaService {
  
  /**
   * Obtener saldo de oficina con desglose
   */
  async obtenerSaldoOficina(): Promise<{
    saldoOficina: number;
    saldoBoveda: number;
    saldoVentanillas: number;
  }> {
    const connection = await pool.getConnection();
    
    try {
      // 1. Obtener saldo de bóveda
      const [bovedaRows] = await connection.query<RowDataPacket[]>(
        'SELECT saldo_efectivo FROM boveda ORDER BY id_boveda DESC LIMIT 1'
      );
      const saldoBoveda = bovedaRows[0]?.saldo_efectivo || 0;

      // 2. Obtener saldo total de ventanillas (suma de saldos_cajero)
      const [ventanillasRows] = await connection.query<RowDataPacket[]>(
        'SELECT COALESCE(SUM(saldo_efectivo), 0) as total_ventanillas FROM saldos_cajero'
      );
      const saldoVentanillas = ventanillasRows[0]?.total_ventanillas || 0;

      // 3. Calcular saldo total de oficina
      const saldoOficina = saldoBoveda + saldoVentanillas;

      return {
        saldoOficina,
        saldoBoveda,
        saldoVentanillas
      };

    } catch (error) {
      console.error('Error en obtenerSaldoOficina:', error);
      throw error;
    } finally {
      connection.release();
    }
  }
}