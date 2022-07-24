import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Party, PartySchema, RequestState } from './sign-party.entity';

@Schema()
export class Record extends Document {
  @Prop()
  subject: string;
  @Prop()
  content: Buffer;
  @Prop()
  owner: string;
  @Prop()
  filename: string;
  @Prop()
  isDraft: boolean;
  @Prop({ type: [{ type: PartySchema }] })
  parties: Party[];
}

export const RecordSchema = SchemaFactory.createForClass(Record);
