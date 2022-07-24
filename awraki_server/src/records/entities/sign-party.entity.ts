import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export enum RequestState {
  PENDING = 'PENDING',
  SIGNED = 'SIGNED',
}

@Schema()
export class Party {

  @Prop()
  userAddress: string;

  @Prop({ enum: RequestState, default: RequestState.PENDING })
  requestState: RequestState;
}

export const PartySchema = SchemaFactory.createForClass(Party);
