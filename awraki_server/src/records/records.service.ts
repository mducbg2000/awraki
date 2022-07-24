import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateRecordDto } from './dto/create-record.dto';
import { UpdateRecordDto } from './dto/update-record.dto';
import { Record } from './entities/record.entity';
import { Party, RequestState } from './entities/sign-party.entity';

@Injectable()
export class RecordsService {
  public constructor(
    @InjectModel(Record.name) private recordRepository: Model<Record>,
  ) {}

  async create(dto: CreateRecordDto) {
    const signerAddresses = new Set(dto.partiesAddresses).add(dto.ownerAddress);
    return this.recordRepository.create({
      subject: dto.subject,
      content: Buffer.from(dto.contentBase64, 'base64'),
      isDraft: dto.isDraft,
      filename: dto.filename,
      owner: dto.ownerAddress,
      parties: Array.from(signerAddresses).map(
        (p) =>
          ({
            userAddress: p,
            requestState:
              !dto.isDraft && p == dto.ownerAddress
                ? RequestState.SIGNED
                : RequestState.PENDING,
          } as Party),
      ),
    });
  }

  async update(id: string, dto: UpdateRecordDto) {
    console.log(dto.partiesAddresses);
    const signerAddresses = new Set(dto.partiesAddresses).add(dto.ownerAddress);
    const record = await this.recordRepository.findById(id);
    if (!record.isDraft)
      throw new BadRequestException(`Cannot modify ${id} document`);
    return this.recordRepository
      .findByIdAndUpdate(id, {
        subject: dto.subject,
        content: Buffer.from(dto.contentBase64, 'base64'),
        isDraft: dto.isDraft,
        filename: dto.filename,
        owner: dto.ownerAddress,
        parties: Array.from(signerAddresses).map(
          (p) =>
            ({
              userAddress: p,
              requestState:
                !dto.isDraft && p == dto.ownerAddress
                  ? RequestState.SIGNED
                  : RequestState.PENDING,
            } as Party),
        ),
      })
      .exec();
  }

  async findAllBySigner(addr: string) {
    return (
      await this.recordRepository
        .find({ isDraft: false })
        .where('parties.userAddress')
        .equals(addr)
        .select('-content -__v')
        .exec()
    ).map((r) => ({
      _id: r._id,
      subject: r.subject,
      owner: r.owner,
      filename: r.filename,
      isDraft: r.isDraft,
      state: r.parties.find((p) => p.userAddress == addr).requestState,
    }));
  }

  async findAllDraftByOwner(addr: string) {
    return (
      await this.recordRepository
        .find({ owner: addr, isDraft: true })
        .select('-content -__v')
        .exec()
    ).map((r) => ({
      _id: r._id,
      subject: r.subject,
      owner: r.owner,
      filename: r.filename,
      isDraft: r.isDraft,
      parties: r.parties.map((p) => p.userAddress),
    }));
  }

  async getContent(id: string) {
    return (
      await this.recordRepository.findById(id).select('content')
    ).content.toString('base64');
  }

  async partySign(id: string, partyAddress: string) {
    const record = await this.recordRepository.findById(id).exec();
    const party = record.parties.find(
      (p) => p.userAddress.valueOf() == partyAddress.valueOf(),
    );
    party.requestState = RequestState.SIGNED;
    return record.save();
  }

  async delete(id: string) {
    return this.recordRepository.findByIdAndDelete(id, { new: true });
  }
}
