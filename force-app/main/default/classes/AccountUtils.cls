public class AccountUtils {
  public static List<Account> accountsByState(String st) {
    List<account> acctList = [
      SELECT Id, Name
      FROM Account
      WHERE BillingState = :st
    ];
    return acctList;
  }
}
