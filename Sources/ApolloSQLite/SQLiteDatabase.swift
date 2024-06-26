import Foundation
#if !COCOAPODS
import Apollo
#endif

public struct DatabaseRow {
  let cacheKey: CacheKey
  let storedInfo: String

  public init(cacheKey: CacheKey, storedInfo: String) {
    self.cacheKey = cacheKey
    self.storedInfo = storedInfo
  }
}

public enum JournalMode: String {
  case delete = "DELETE"
  case truncate = "TRUNCATE"
  case persist = "PERSIST"
  case wal = "WAL"
  case memory = "MEMORY"
  case off = "OFF"
}

public protocol SQLiteDatabase {
  
  init(fileURL: URL) throws

  func setJournalMode(_ journalMode: JournalMode) throws

  func createRecordsTableIfNeeded() throws
  
  func selectRawRows(forKeys keys: Set<CacheKey>) throws -> [DatabaseRow]

  func addOrUpdateRecordString(_ recordString: String, for cacheKey: CacheKey) throws
  
  func deleteRecord(for cacheKey: CacheKey) throws

  func deleteRecords(matching pattern: CacheKey) throws
  
  func clearDatabase(shouldVacuumOnClear: Bool) throws
  
}

public extension SQLiteDatabase {
  
  static var tableName: String {
    "records"
  }
  
  static var idColumnName: String {
    "_id"
  }

  static var keyColumnName: String {
    "key"
  }

  static var recordColumName: String {
    "record"
  }
}
