import {
  Controller,
  Post,
  Body,
  Put,
  Param,
  Get,
  Logger,
  Header,
  Delete,
  BadRequestException,
  Patch,
  Query,
} from '@nestjs/common';
import { RecordsService } from './records.service';
import { CreateRecordDto } from './dto/create-record.dto';
import { ApiTags } from '@nestjs/swagger';
import { UpdateRecordDto } from './dto/update-record.dto';

@Controller('records')
@ApiTags('Sign Document')
export class RecordsController {
  private readonly logger = new Logger(RecordsController.name);

  constructor(private readonly recordsService: RecordsService) {}

  @Post()
  create(@Body() createRecordDto: CreateRecordDto) {
    return this.recordsService.create(createRecordDto);
  }

  @Patch(':id')
  partySign(@Param('id') docId: string, @Body() dto: any) {
    return this.recordsService.partySign(docId, dto.partyAddress);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() dto: UpdateRecordDto) {
    return this.recordsService.update(id, dto);
  }

  @Get('')
  get(@Query('owner') owner?: string, @Query('signer') signer?: string) {
    if (owner != null && owner.trim().length > 0)
      return this.recordsService.findAllDraftByOwner(owner);
    if (signer != null && signer.trim().length > 0)
      return this.recordsService.findAllBySigner(signer);
    throw new BadRequestException('Param must not be empty');
  }

  @Get('/:id')
  getContent(@Param('id') id: string) {
    return this.recordsService.getContent(id);
  }

  @Delete('/:id')
  delete(@Param('id') id: string) {
    return this.recordsService.delete(id);
  }
}
