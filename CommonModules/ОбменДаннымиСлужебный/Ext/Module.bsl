﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ЗагрузитьЧастьФайла(ИдентификаторФайла, НомерЗагружаемойЧастиФайла, ЗагружаемаяЧастьФайла, СообщениеОбОшибке) Экспорт
	
	СообщениеОбОшибке = "";
	
	Если Не ЗначениеЗаполнено(ИдентификаторФайла) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Не указан идентификатор загружаемого файла. Дальнейшее выполнение метода невозможно.
				|Необходимо для загружаемого файла назначить уникальный идентификатор.'");
		ВызватьИсключение(СообщениеОбОшибке);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЗагружаемаяЧастьФайла)
		И ТипЗнч(ЗагружаемаяЧастьФайла) <> Тип("ДвоичныеДанные") Тогда
		СообщениеОбОшибке = НСтр("ru = 'Метод не может быть выполнен, т.к. переданные данные не соответствуют типу для получения данных.'");
		ВызватьИсключение(СообщениеОбОшибке);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерЗагружаемойЧастиФайла) 
		Или НомерЗагружаемойЧастиФайла = 0 Тогда
		НомерЗагружаемойЧастиФайла = 1;
	КонецЕсли;
	
	КаталогВременныхФайлов = ВременныйКаталогВыгрузки(ИдентификаторФайла);
	
	Каталог = Новый Файл(КаталогВременныхФайлов);
	Если Не Каталог.Существует() Тогда
		СоздатьКаталог(КаталогВременныхФайлов);
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов, ПолучитьИмяЧастиФайла(НомерЗагружаемойЧастиФайла));
	ЗагружаемаяЧастьФайла.Записать(ИмяФайла);
	
КонецФункции

Функция ВыгрузитьЧастьФайла(ИдентификаторФайла, НомерВыгружаемойЧастиФайла, СообщениеОбОшибке) Экспорт
	
	СообщениеОбОшибке      = "";
	ИмяЧастиФайла          = "";
	КаталогВременныхФайлов = ВременныйКаталогВыгрузки(ИдентификаторФайла);
	
	Для КоличествоРазрядов = СтрДлина(Формат(НомерВыгружаемойЧастиФайла, "ЧДЦ=0; ЧГ=0")) По 5 Цикл
		
		ФорматнаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧЦ=%1; ЧВН=; ЧГ=0", Строка(КоличествоРазрядов));
		
		ИмяФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.zip.%2", ИдентификаторФайла, Формат(НомерВыгружаемойЧастиФайла, ФорматнаяСтрока));
		
		ИменаФайлов = НайтиФайлы(КаталогВременныхФайлов, ИмяФайла);
		
		Если ИменаФайлов.Количество() > 0 Тогда
			
			ИмяЧастиФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов, ИмяФайла);
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧастьФайла = Новый Файл(ИмяЧастиФайла);
	
	Если ЧастьФайла.Существует() Тогда
		Возврат Новый ДвоичныеДанные(ИмяЧастиФайла);
	Иначе
		СообщениеОбОшибке = НСтр("ru = 'Часть файла с указанным номером не найдена.'");
	КонецЕсли;
	
КонецФункции

Функция ПодготовитьФайлДляЗагрузки(ИдентификаторФайла, СообщениеОбОшибке) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторФайлаВоВременномХранилище = "";
	
	КаталогВременныхФайлов = ВременныйКаталогВыгрузки(ИдентификаторФайла);
	ИмяАрхива              = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов, "datafile.zip");
	
	МассивПолученныхФайлов = НайтиФайлы(КаталогВременныхФайлов,"data.zip.*");
	
	Если МассивПолученныхФайлов.Количество() > 0 Тогда
		
		ФайлыДляОбъединения = Новый Массив();
		ИмяЧастиФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов, "data.zip.%1");
		
		Для НомерЧасти = 1 По МассивПолученныхФайлов.Количество() Цикл
			ФайлыДляОбъединения.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИмяЧастиФайла, НомерЧасти));
		КонецЦикла;
		
	Иначе
		ШаблонСообщения = НСтр("ru = 'Не найден ни один фрагмент сессии передачи с идентификатором %1.
				|Необходимо убедиться, что в настройках программы заданы параметры
				|""Каталог временных файлов для Linux"" и ""Каталог временных файлов для Windows"".'");
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(ИдентификаторФайла));
		ВызватьИсключение(СообщениеОбОшибке);
	КонецЕсли;
	
	Попытка 
		ОбъединитьФайлы(ФайлыДляОбъединения, ИмяАрхива);
	Исключение
		СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение(СообщениеОбОшибке);
	КонецПопытки;
	
	// Распаковать.
	Разархиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Если Разархиватор.Элементы.Количество() = 0 Тогда
		
		Попытка
			УдалитьФайлы(КаталогВременныхФайлов);
		Исключение
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
				УровеньЖурналаРегистрации.Ошибка,,, СообщениеОбОшибке);
			ВызватьИсключение(СообщениеОбОшибке);
		КонецПопытки;
		
		СообщениеОбОшибке = НСтр("ru = 'Файл архива не содержит данных.'");
		ВызватьИсключение(СообщениеОбОшибке);
		
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВременныхФайлов, Разархиватор.Элементы[0].Имя);
	Разархиватор.Извлечь(Разархиватор.Элементы[0], КаталогВременныхФайлов);
	Разархиватор.Закрыть();
	
	// Помещаем файл в каталог временного хранилища файлов.
	КаталогЗагрузки          = ОбменДаннымиПовтИсп.КаталогВременногоХранилищаФайлов();
	ИмяФайлаСДанными         = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(ИдентификаторФайла, ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла));
	ИмяФайлаВКаталогеЗагрузки = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогЗагрузки, ИмяФайлаСДанными);
	
	Попытка
		ПереместитьФайл(ИмяФайла, ИмяФайлаВКаталогеЗагрузки);
	Исключение
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, СообщениеОбОшибке);
		ВызватьИсключение(СообщениеОбОшибке);
	КонецПопытки;
	
	ИдентификаторФайлаВоВременномХранилище = ОбменДаннымиСервер.ПоместитьФайлВХранилище(ИмяФайлаВКаталогеЗагрузки);
	
	// Удаляем временные файлы.
	Попытка
		УдалитьФайлы(КаталогВременныхФайлов);
	Исключение
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, СообщениеОбОшибке);
		ВызватьИсключение(СообщениеОбОшибке);
	КонецПопытки;
	
	Возврат ИдентификаторФайлаВоВременномХранилище;
	
КонецФункции

Процедура ПодготовитьДанныеДляВыгрузкиИзИнформационнойБазы(ПараметрыПроцедуры, АдресХранилища) Экспорт
	
	ПараметрыWEBСервиса = ПараметрыПроцедуры["ПараметрыWEBСервиса"];
	СообщениеОбОшибке   = ПараметрыПроцедуры["СообщениеОбОшибке"];
	
	УстановитьПривилегированныйРежим(Истина);
	
	КомпонентыОбмена = КомпонентыОбмена("Отправка", ПараметрыWEBСервиса);
	ИмяФайла         = Строка(Новый УникальныйИдентификатор()) + ".xml";
	
	КаталогВременныхФайлов = ОбменДаннымиПовтИсп.КаталогВременногоХранилищаФайлов();
	ПолноеИмяФайла         = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогВременныхФайлов, ИмяФайла);
		
	// Открываем файл обмена.
	ОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена, ПолноеИмяФайла);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		
		ВызватьИсключение КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	СтруктураНастроекОбмена = СтруктураНастроекОбмена(КомпонентыОбмена, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	
	// Выгрузка данных.
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиВыгрузкуДанных(КомпонентыОбмена);
	Исключение
		
		Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
			РазблокироватьДанныеДляРедактирования(КомпонентыОбмена.УзелКорреспондента);
		КонецЕсли;
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СообщениеОбОшибке);
		ОбменДаннымиXDTOСервер.ЗавершитьВедениеПротоколаОбмена(КомпонентыОбмена);
		
		КомпонентыОбмена.ФайлОбмена = Неопределено;
		
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена, КомпонентыОбмена);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		
		СообщениеОбОшибке = КомпонентыОбмена.СтрокаСообщенияОбОшибке;
		ВызватьИсключение СообщениеОбОшибке;
		
	Иначе
		
		// Поместить файл во временное хранилище.
		ИдентификаторФайлаВоВременномХранилище = Строка(ОбменДаннымиСервер.ПоместитьФайлВХранилище(ПолноеИмяФайла));
		
		// Создаем временный каталог для хранения частей файла данных.
		ВременныйКаталог                     = ВременныйКаталогВыгрузки(
			ИдентификаторФайлаВоВременномХранилище);
		ИмяНеразделенногоФайла               = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
			ВременныйКаталог, ИдентификаторФайлаВоВременномХранилище + ?(ПараметрыWEBСервиса.РазмерЧастиФайла > 0, ".zip", ".zip.1"));
		ИмяИсходногоФайлаВоВременномКаталоге = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
			ВременныйКаталог, "data.xml");
		
		СоздатьКаталог(ВременныйКаталог);
		КопироватьФайл(ПолноеИмяФайла, ИмяИсходногоФайлаВоВременномКаталоге);
		
		// Архивируем файл.
		Архиватор = Новый ЗаписьZipФайла(ИмяНеразделенногоФайла);
		Архиватор.Добавить(ИмяИсходногоФайлаВоВременномКаталоге);
		Архиватор.Записать();
		
		Если ПараметрыWEBСервиса.РазмерЧастиФайла > 0 Тогда
			// Разделение файла на части.
			ИменаФайлов = РазделитьФайл(ИмяНеразделенногоФайла, ПараметрыWEBСервиса.РазмерЧастиФайла * 1024);
		Иначе
			ИменаФайлов = Новый Массив();
			ИменаФайлов.Добавить(ИмяНеразделенногоФайла);
		КонецЕсли;
		
		ВозвращаемоеЗначение = "{WEBService}$%1$%2";
		ВозвращаемоеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ВозвращаемоеЗначение, ИменаФайлов.Количество(), ИдентификаторФайлаВоВременномХранилище);
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = ВозвращаемоеЗначение;
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьДанныеXDTOВИнформационнуюБазу(ПараметрыПроцедуры, АдресХранилища) Экспорт
	
	ПараметрыWEBСервиса = ПараметрыПроцедуры["ПараметрыWEBСервиса"];
	СообщениеОбОшибке   = ПараметрыПроцедуры["СообщениеОбОшибке"];
	
	УстановитьПривилегированныйРежим(Истина);
	
	КомпонентыОбмена = КомпонентыОбмена("Получение", ПараметрыWEBСервиса);
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		СообщениеОбОшибке = КомпонентыОбмена.СтрокаСообщенияОбОшибке;
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
	СтруктураНастроекОбмена = СтруктураНастроекОбмена(КомпонентыОбмена, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
	Исключение
		
		СообщениеОбОшибке = НСтр("ru = 'Ошибка при загрузке данных: %1'");
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ОписаниеОшибки());
		ОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, СообщениеОбОшибке,,,,,Истина);
		КомпонентыОбмена.ФлагОшибки = Истина;
		
		ВызватьИсключение(СообщениеОбОшибке);
		
	КонецПопытки;
	
	ОбменДаннымиXDTOСервер.УдалитьВременныеОбъектыСозданныеПоСсылкам(КомпонентыОбмена);
	
	КомпонентыОбмена.ФайлОбмена.Закрыть();
	
	ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена, КомпонентыОбмена);
	
	Если Не КомпонентыОбмена.ФлагОшибки 
		И КомпонентыОбмена.ЭтоОбменЧерезПланОбмена
		И КомпонентыОбмена.ИспользоватьКвитирование Тогда
		
		// Запишем информацию о номере входящего сообщения.
		ОбъектУзла = КомпонентыОбмена.УзелКорреспондента.ПолучитьОбъект();
		ОбъектУзла.НомерПринятого = КомпонентыОбмена.НомерВходящегоСообщения;
		ОбъектУзла.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
		ОбъектУзла.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныйКаталогВыгрузки(Знач ИдентификаторСессии) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = "{ИдентификаторСессии}";
	ВременныйКаталог = СтрЗаменить(ВременныйКаталог, "ИдентификаторСессии", Строка(ИдентификаторСессии));
	
	Результат = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбменДаннымиПовтИсп.КаталогВременногоХранилищаФайлов(), ВременныйКаталог);
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьВозможностьВыполненияОбменов() Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.ОбщиеКоманды.Синхронизировать) Тогда
		
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для синхронизации данных.'");
		
	ИначеЕсли ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы()
		И Не ОбменДаннымиВызовСервера.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена") Тогда
		
		ВызватьИсключение НСтр("ru = 'Информационная база находится в состоянии обновления.'");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьБлокировкуИнформационнойБазыДляОбновления() Экспорт
	
	Если ЗначениеЗаполнено(ОбновлениеИнформационнойБазыСлужебный.ИнформационнаяБазаЗаблокированаДляОбновления()) Тогда
		
		ВызватьИсключение НСтр("ru = 'Синхронизация данных временно недоступна в связи с обновлением приложения.'");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСтатусВыполненияПолученияДанных(ИдентификаторДлительнойОперации, СообщениеОбОшибке) Экспорт
	
	СообщениеОбОшибке = "";
	
	УстановитьПривилегированныйРежим(Истина);
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторДлительнойОперации));
	
	СостоянияФоновогоЗадания = СостоянияФоновыхЗаданий();
	Если ФоновоеЗадание = Неопределено Тогда
		СостояниеТекущегоФоновогоЗадания = СостоянияФоновогоЗадания.Получить(СостояниеФоновогоЗадания.Отменено);
	Иначе
		
		Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		КонецЕсли;
		СостояниеТекущегоФоновогоЗадания = СостоянияФоновогоЗадания.Получить(ФоновоеЗадание.Состояние)
		
	КонецЕсли;
	
	Возврат СостояниеТекущегоФоновогоЗадания;
	
КонецФункции

Функция ПолучитьСтатусВыполненияПодготовкиДанныхКОтправке(ИдентификаторФоновогоЗадания, СообщениеОбОшибке) Экспорт
	
	СообщениеОбОшибке = "";
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВозвращаемаяСтруктура = ФабрикаXDTO.Создать(
		ФабрикаXDTO.Тип("http://v8.1c.ru/SSL/Exchange/EnterpriseDataExchange", "PrepareDataOperationResult"));
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторФоновогоЗадания));
	
	Если ФоновоеЗадание = Неопределено Тогда
		СостояниеТекущегоФоновогоЗадания = СостоянияФоновыхЗаданий().Получить(СостояниеФоновогоЗадания.Отменено);
	Иначе
	
		СообщениеОбОшибке        = "";
		КоличествоЧастейФайла    = 0;
		ИдентификаторФайла       = "";
		СостояниеТекущегоФоновогоЗадания = СостоянияФоновыхЗаданий().Получить(ФоновоеЗадание.Состояние);
		
		Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		Иначе
			Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
				МассивСообщений  = ФоновоеЗадание.ПолучитьСообщенияПользователю(Истина);
				Для Каждого СообщениеФоновогоЗадания Из МассивСообщений Цикл
					Если СтрНайти(СообщениеФоновогоЗадания.Текст, "{WEBService}") > 0 Тогда
						МассивРезультата = СтрРазделить(СообщениеФоновогоЗадания.Текст, "$", Истина);
						КоличествоЧастейФайла = МассивРезультата[1];
						ИдентификаторФайла    = МассивРезультата[2];
						Прервать;
					Иначе
						Продолжить;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ВозвращаемаяСтруктура.ErrorMessage = СообщениеОбОшибке;
	ВозвращаемаяСтруктура.FileID       = ИдентификаторФайла;
	ВозвращаемаяСтруктура.PartCount    = КоличествоЧастейФайла;
	ВозвращаемаяСтруктура.Status       = СостояниеТекущегоФоновогоЗадания;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

Функция ИнициализироватьПараметрыWebСервиса() Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяПланаОбмена");
	СтруктураПараметров.Вставить("КодУзлаПланаОбмена");
	СтруктураПараметров.Вставить("ИдентификаторФайлаВоВременномХранилище");
	СтруктураПараметров.Вставить("РазмерЧастиФайла");
	СтруктураПараметров.Вставить("ИмяWEBСервиса");

	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КомпонентыОбмена(НаправлениеОбмена, ПараметрыWEBСервиса)
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена(НаправлениеОбмена);
	
	Если ЗначениеЗаполнено(ПараметрыWEBСервиса.ИмяПланаОбмена) И ЗначениеЗаполнено(ПараметрыWEBСервиса.КодУзлаПланаОбмена) Тогда
		КомпонентыОбмена.УзелКорреспондента = ПланыОбмена[ПараметрыWEBСервиса.ИмяПланаОбмена].НайтиПоКоду(ПараметрыWEBСервиса.КодУзлаПланаОбмена);
	Иначе
		КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	КонецЕсли;
	
	КомпонентыОбмена.ВедениеПротоколаДанных.ВыводВПротоколИнформационныхСообщений = Ложь;
	КомпонентыОбмена.СостояниеОбменаДанными.ДатаНачала = ТекущаяДатаСеанса();
	КомпонентыОбмена.ИспользоватьТранзакции = Ложь;

	Если НаправлениеОбмена = "Получение" Тогда
		
		КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = СформироватьКлючСообщенияЖР(НаправлениеОбмена, ПараметрыWEBСервиса);
		
		ИмяФайла = ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ПараметрыWEBСервиса.ИдентификаторФайлаВоВременномХранилище);
		ОбменДаннымиXDTOСервер.ОткрытьФайлЗагрузки(КомпонентыОбмена, ИмяФайла);
		
	Иначе
		
		КомпонентыОбмена.КлючСообщенияЖурналаРегистрации   = СформироватьКлючСообщенияЖР(НаправлениеОбмена, ПараметрыWEBСервиса);
		КомпонентыОбмена.ВерсияФорматаОбмена               = ОбменДаннымиXDTOСервер.ВерсияФорматаОбменаПриВыгрузке(
			КомпонентыОбмена.УзелКорреспондента);
		КомпонентыОбмена.XMLСхема                          = ОбменДаннымиXDTOСервер.ФорматОбмена(
			ПараметрыWEBСервиса.ИмяПланаОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
		КомпонентыОбмена.МенеджерОбмена                    = ОбменДаннымиXDTOСервер.МенеджерОбменаВерсииФормата(
			КомпонентыОбмена.ВерсияФорматаОбмена, КомпонентыОбмена.УзелКорреспондента);
		КомпонентыОбмена.ТаблицаПравилаРегистрацииОбъектов = ОбменДаннымиXDTOСервер.ПравилаРегистрацииОбъектов(
			КомпонентыОбмена.УзелКорреспондента);
		КомпонентыОбмена.СвойстваУзлаПланаОбмена           = ОбменДаннымиXDTOСервер.СвойстваУзлаПланаОбмена(
			КомпонентыОбмена.УзелКорреспондента);
		
	КонецЕсли;
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		Возврат КомпонентыОбмена;
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	Если КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
		ОбменДаннымиXDTOСервер.ЗаполнитьСтруктуруНастроекXDTO(КомпонентыОбмена);
		ОбменДаннымиXDTOСервер.ЗаполнитьПоддерживаемыеОбъектыXDTO(КомпонентыОбмена);
	КонецЕсли;
	
	Возврат КомпонентыОбмена;
	
КонецФункции

Функция ПолучитьИмяЧастиФайла(НомерЧастиФайла, ИмяАрхива = "")
	
	Если Не ЗначениеЗаполнено(ИмяАрхива) Тогда
		ИмяАрхива = "data";
	КонецЕсли;
	
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.zip.%2", ИмяАрхива, Формат(НомерЧастиФайла, "ЧГ=0"));
	
	Возврат Результат;
	
КонецФункции

Функция СостоянияФоновыхЗаданий()
	
	СостоянияФоновогоЗадания = Новый Соответствие;
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Активно,           "Active");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Завершено,         "Completed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.ЗавершеноАварийно, "Failed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Отменено,          "Canceled");
	
	Возврат СостоянияФоновогоЗадания;
	
КонецФункции

Функция СформироватьКлючСообщенияЖР(НаправлениеОбмена, ПараметрыWEBСервиса)
	
	Если НаправлениеОбмена = "Получение" Тогда
		ШаблонКлючаСообщения = НСтр("ru = 'Загрузка данных через Web-сервис %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Иначе
		ШаблонКлючаСообщения = НСтр("ru = 'Выгрузка данных через Web-сервис %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонКлючаСообщения, ПараметрыWEBСервиса.ИмяWEBСервиса);
	
КонецФункции

Функция СтруктураНастроекОбмена(КомпонентыОбмена, ДействиеОбменаДанными)
	
	Если Не КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураНастроекОбмена = ОбменДаннымиПовтИсп.НастройкиОбменаУзлаИнформационнойБазы(
		КомпонентыОбмена.УзелКорреспондента, ДействиеОбменаДанными, Неопределено, Ложь);
		
	Если СтруктураНастроекОбмена.Отказ Тогда
		СтрокаСообщенияОбОшибке = НСтр("ru = 'Ошибка при инициализации процесса обмена данными.'");
		ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	СтруктураНастроекОбмена.РезультатВыполненияОбмена = Неопределено;
	СтруктураНастроекОбмена.ДатаНачала = ТекущаяДатаСеанса();
	
	СтрокаСообщения = НСтр("ru = 'Начало процесса обмена данными для узла %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, СтруктураНастроекОбмена.УзелИнформационнойБазыНаименование);
	
	ЗаписьЖурналаРегистрации(СтруктураНастроекОбмена.КлючСообщенияЖурналаРегистрации, 
		УровеньЖурналаРегистрации.Информация,
		СтруктураНастроекОбмена.УзелИнформационнойБазы.Метаданные(),
		СтруктураНастроекОбмена.УзелИнформационнойБазы,
		СтрокаСообщения);
		
	Возврат СтруктураНастроекОбмена;
	
КонецФункции

Процедура ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена, КомпонентыОбмена)
	
	Если Не КомпонентыОбмена.ЭтоОбменЧерезПланОбмена Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураНастроекОбмена.РезультатВыполненияОбмена    = КомпонентыОбмена.СостояниеОбменаДанными.РезультатВыполненияОбмена;
	
	Если СтруктураНастроекОбмена.ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных Тогда
		СтруктураНастроекОбмена.КоличествоОбъектовОбработано = КомпонентыОбмена.СчетчикВыгруженныхОбъектов;
		СтруктураНастроекОбмена.СообщениеПриОбмене           = СтруктураНастроекОбмена.ОбработкаОбменаДанными.КомментарийПриВыгрузкеДанных;
	ИначеЕсли СтруктураНастроекОбмена.ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ЗагрузкаДанных Тогда
		СтруктураНастроекОбмена.КоличествоОбъектовОбработано = КомпонентыОбмена.СчетчикЗагруженныхОбъектов;
		СтруктураНастроекОбмена.СообщениеПриОбмене           = СтруктураНастроекОбмена.ОбработкаОбменаДанными.КомментарийПриЗагрузкеДанных;
	КонецЕсли;
	
	СтруктураНастроекОбмена.СтрокаСообщенияОбОшибке      = КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
	
КонецПроцедуры

#КонецОбласти