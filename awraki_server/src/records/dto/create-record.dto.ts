export class CreateRecordDto {
  subject: string;
  isDraft: boolean;
  contentBase64: string;
  filename: string;
  ownerAddress: string;
  partiesAddresses: string[];
}
