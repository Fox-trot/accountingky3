﻿
#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы Физического лица

Процедура ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Перем ИмяТекущегоЭлемента;
	
	Форма.СозданиеНового = Форма.Параметры.Ключ.Пустая();
	
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		Форма.ФизическоеЛицоСсылка 	= Справочники.ФизическиеЛица.ПолучитьСсылку();
		Форма.ФизЛицо.ФИО 			= Форма.ФизЛицо.Наименование;

		// Если это форма нового объекта - инициализация реквизитов формы, 
		// предназначенных для редактирования дополнительных
		// данных (помимо основного редактируемого объекта)
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "ФИОФизическихЛиц", Форма.ФизическоеЛицоСсылка);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "ГражданствоФизическихЛиц", Форма.ФизическоеЛицоСсылка);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "ДокументыФизическихЛиц", Форма.ФизическоеЛицоСсылка);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "СоставыСемейФизическихЛиц", Форма.ФизическоеЛицоСсылка);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "СостоянияВБракеФизическихЛиц", Форма.ФизическоеЛицоСсылка);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "ОбразованиеФизическихЛиц",Форма.ФизическоеЛицоСсылка);
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "ЗнаниеЯзыковФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	КонецЕсли;
	
	СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(Форма);

	Если Форма.Параметры.Свойство("ТекущийЭлемент", ИмяТекущегоЭлемента) Тогда
		ТекущийЭлемент = Форма.Элементы[ИмяТекущегоЭлемента];		
	КонецЕсли;	
КонецПроцедуры

Процедура ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	Форма.ФизическоеЛицоСсылка  = Форма.ФизЛицо.Ссылка;
	СотрудникиФормы.ПрочитатьДанныеСвязанныеСФизЛицом(Форма, Истина);
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "ГражданствоФизическихЛиц", Форма.ФизическоеЛицоСсылка);
	Если ЗначениеЗаполнено(Форма.ГражданствоФизическихЛиц.Страна) Тогда
		Форма.ГражданствоФизическихЛицЛицоБезГражданства = 0;
	Иначе
		Форма.ГражданствоФизическихЛицЛицоБезГражданства = 1;
	КонецЕсли;
	
	ПрочитатьЗаписьОДокументеУдостоверяющемЛичностьДляРедактированияВФорме(Форма, Форма.ФизическоеЛицоСсылка);
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "СостоянияВБракеФизическихЛиц", Форма.ФизическоеЛицоСсылка);
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"СоставыСемейФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"ОбразованиеФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"ЗнаниеЯзыковФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"КвалификацияФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"ПоощренияИВзыскания",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"ТрудоваяДеятельностьФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"ВоинскийУчетФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"УченыеСтепениФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(Форма,"УченыеЗванияФизическихЛиц",Форма.ФизическоеЛицоСсылка);
КонецПроцедуры

Процедура ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	Перем ДополнительныеСвойства;
	
	Если Форма.СозданиеНового Тогда
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		
		ГражданствоПоУмолчанию = Форма.ГражданствоФизическихЛиц.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
			
		СотрудникиФормы.ЗаписатьЗначенияПоУмолчанию(Форма.ФизическоеЛицоСсылка, ГражданствоПоУмолчанию);
		
	КонецЕсли;
	
	СотрудникиФормы.ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, Форма.ФизическоеЛицоСсылка);	
		
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(
		Форма,
		"ГражданствоФизическихЛиц",
		Форма.ФизическоеЛицоСсылка,
		,
		ДополнительныеСвойства);
		
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(
		Форма,
		"СостоянияВБракеФизическихЛиц",
		Форма.ФизическоеЛицоСсылка,
		,
		ДополнительныеСвойства);
		
	ЗаписатьЗаписьДокументыФизическихЛицПослеРедактированияВФорме(Форма, Форма.ФизическоеЛицоСсылка);
	
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"СоставыСемейФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"ОбразованиеФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"ЗнаниеЯзыковФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"КвалификацияФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"ПоощренияИВзыскания",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"ТрудоваяДеятельностьФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"ВоинскийУчетФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"УченыеСтепениФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	РедактированиеПериодическихСведений.ЗаписатьНаборЗаписей(Форма,"УченыеЗванияФизическихЛиц",Форма.ФизическоеЛицоСсылка);
	
КонецПроцедуры

Процедура ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	СотрудникиФормы.ПрочитатьДанныеСвязанныеСФизЛицом(Форма);
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "ГражданствоФизическихЛиц", Форма.ФизическоеЛицоСсылка);
	Если ЗначениеЗаполнено(Форма.ГражданствоФизическихЛиц.Страна) Тогда
		Форма.ГражданствоФизическихЛицЛицоБезГражданства = 0;
	Иначе
		Форма.ГражданствоФизическихЛицЛицоБезГражданства = 1;
	КонецЕсли;
	ПрочитатьЗаписьОДокументеУдостоверяющемЛичностьДляРедактированияВФорме(Форма, Форма.ФизическоеЛицоСсылка);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(Форма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Процедура ЗаполнитьПервоначальныеЗначения(Форма) Экспорт
	ЗначенияДляЗаполнения = Новый Структура;
	ЗначенияДляЗаполнения.Вставить("Организация", "ТекущаяОрганизация");
	ЗначенияДляЗаполнения.Вставить("Подразделение", "ТекущееПодразделение");
КонецПроцедуры

Процедура ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация) Экспорт
	
	ИзменилосьФИО = Ложь;
	ИзменилосьУдостоверениеЛичности = Ложь;
	
	НачатьТранзакцию();
	
	ИзменилосьФИО = РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(Форма, "ФИОФизическихЛиц", ФизическоеЛицоСсылка, ИзменилосьФИО);
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры	

Процедура ПрочитатьДанныеСвязанныеСФизЛицом(Форма, Организация, ИзФормыСотрудника) Экспорт
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "ФИОФизическихЛиц", Форма.ФизическоеЛицоСсылка);
	ПрочитатьЗаписьОДокументеУдостоверяющемЛичностьДляРедактированияВФорме(Форма, Форма.ФизическоеЛицоСсылка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры чтения / записи данных документов удостоверяющих личность

Процедура ПрочитатьЗаписьОДокументеУдостоверяющемЛичностьДляРедактированияВФорме(Форма, ВедущийОбъект) Экспорт
	
	Если Форма.Параметры.Свойство("Ключ") И НЕ Форма.Параметры.Ключ.Пустая() Тогда
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(Форма, "ДокументыФизическихЛиц", ВедущийОбъект);
	КонецЕсли;
	
	МенеджерЗаписи = МенеджерПоследнейЗаписиДокументовФизическихЛиц(ВедущийОбъект);
	
	МетаданныеРегистра = Метаданные.РегистрыСведений["ДокументыФизическихЛиц"];
	
	// имя реквизита формы совпадает с именем регистра
	Форма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "ДокументыФизическихЛиц");
	
	ЗаписьКакСтруктура = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписи, МетаданныеРегистра);
	Форма["ДокументыФизическихЛицПрежняя"] = Новый ФиксированнаяСтруктура(ЗаписьКакСтруктура);
	
	Форма["ДокументыФизическихЛицНоваяЗапись"] = Ложь;
	
КонецПроцедуры

Функция МенеджерПоследнейЗаписиДокументовФизическихЛиц(ВедущийОбъект) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений["ДокументыФизическихЛиц"];
	
	МенеджерЗаписи = РегистрыСведений["ДокументыФизическихЛиц"].СоздатьМенеджерЗаписи();
	МенеджерЗаписи["ФизЛицо"] = ВедущийОбъект;
	
	// Ищем последнюю запись
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	РегистрСведений.Период КАК Период,
		|	РегистрСведений.ФизЛицо КАК ФизЛицо,
		|	РегистрСведений.ВидДокумента КАК ВидДокумента
		|ИЗ
		|	РегистрСведений.ДокументыФизическихЛиц КАК РегистрСведений
		|ГДЕ
		|	РегистрСведений.ФизЛицо = &ВедущийОбъект
		|	И РегистрСведений.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.Паспорт)
		|
		|УПОРЯДОЧИТЬ ПО
		|	РегистрСведений.Период УБЫВ";
	Запрос.УстановитьПараметр("ВедущийОбъект", ВедущийОбъект);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
	КонецЕсли;
	
	Возврат МенеджерЗаписи;
	
КонецФункции

Функция ЗаписатьЗаписьДокументыФизическихЛицПослеРедактированияВФорме(Форма, ВедущийОбъект)
	
	Если Форма["ДокументыФизическихЛицНаборЗаписейПрочитан"] Тогда
		Возврат ЗаписатьНаборЗаписейДокументыФизическихЛицПослеРедактированияВФорме(Форма, ВедущийОбъект);
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений["ДокументыФизическихЛиц"];
	ИмяИзмерения = МетаданныеРегистра.Измерения[0].Имя;

	Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		ИзменилисьДанные = Форма["ДокументыФизическихЛиц"].Период <> Форма["ДокументыФизическихЛицПрежняя"].Период;
	Иначе
		ИзменилисьДанные = Ложь;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		ИзменилисьДанные = ИзменилисьДанные ИЛИ 
		(ВедущийОбъект <> Форма["ДокументыФизическихЛицПрежняя"][ИмяИзмерения] И 
		ЗначениеЗаполнено(Форма["ДокументыФизическихЛицПрежняя"][ИмяИзмерения]));
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Измерения Цикл
			Если Поле.Имя = ИмяИзмерения Тогда
				Продолжить;
			КонецЕсли; 
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма["ДокументыФизическихЛиц"][Поле.Имя] <> Форма["ДокументыФизическихЛицПрежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Ресурсы Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма["ДокументыФизическихЛиц"][Поле.Имя] <> Форма["ДокументыФизическихЛицПрежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Реквизиты Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма["ДокументыФизическихЛиц"][Поле.Имя] <> Форма["ДокументыФизическихЛицПрежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Если ИзменилисьДанные Тогда
		// пишем новое состояние записи
		МенеджерЗаписи = Форма.РеквизитФормыВЗначение("ДокументыФизическихЛиц");
		МенеджерЗаписи[ИмяИзмерения] = ВедущийОбъект;
		
		// Записываем только с заполнеными серией и номером.
		Если НЕ (ЗначениеЗаполнено(МенеджерЗаписи.Номер) 
			И ЗначениеЗаполнено(МенеджерЗаписи.Серия)) Тогда
			Возврат Ложь;
		КонецЕсли;	
		
		// Из формы можно записывать только данные паспорта.
		Если НЕ ЗначениеЗаполнено(МенеджерЗаписи.ВидДокумента) Тогда 
			МенеджерЗаписи.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.Паспорт;
		КонецЕсли;	
		
		// если нужно сохранить старую запись, то создадим новый менеджер записи
		Если Форма["ДокументыФизическихЛицНоваяЗапись"] Тогда
			НоваяЗапись = РегистрыСведений["ДокументыФизическихЛиц"].СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, МенеджерЗаписи);
			НоваяЗапись.Записать();
		Иначе
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИзменилисьДанные;
	
КонецФункции

Функция ЗаписатьНаборЗаписейДокументыФизическихЛицПослеРедактированияВФорме(Форма, ВедущийОбъект)
	
	ИзменилисьДанные = Ложь;
	
	СотрудникиКлиентСервер.ОбновитьНаборЗаписейИсторииДокументыФизическихЛиц(Форма, ВедущийОбъект);

	ИмяИзмерения = Метаданные.РегистрыСведений["ДокументыФизическихЛиц"].Измерения[0].Имя;
	
	// Подготовим к сравнению набор исходных сведений
	Набор = РегистрыСведений["ДокументыФизическихЛиц"].СоздатьНаборЗаписей();
	Набор.Отбор[ИмяИзмерения].Установить(ВедущийОбъект);
	Набор.Прочитать();
	ТаблицаИсходногоНабора = Набор.Выгрузить();
	
	// Подготовим к сравнению набор, хранящийся в реквизите формы
	ТаблицаНовогоНабора = Форма["ДокументыФизическихЛицНаборЗаписей"].Выгрузить();
	ТаблицаНовогоНабора.Колонки.Удалить("ИсходныйНомерСтроки");
	
	// Проверим необходимость записи нового набора
	Если НЕ ОбщегоНазначения.КоллекцииИдентичны(ТаблицаИсходногоНабора, ТаблицаНовогоНабора, , "Представление") Тогда
		
		ИзменилисьДанные = Истина;
		МассивСохраняемыхСтрок = Новый Массив;
		
		Для Каждого СтрокаТаблицаНовогоНабора Из ТаблицаНовогоНабора Цикл
			
			СохранитьСтроку = Истина;
			СтрокиТаблицыИсходногоНабора = ТаблицаИсходногоНабора.НайтиСтроки(Новый Структура("Период,ВидДокумента", СтрокаТаблицаНовогоНабора.Период, СтрокаТаблицаНовогоНабора.ВидДокумента));
			Если СтрокиТаблицыИсходногоНабора.Количество() > 0 Тогда
				СтрокаТаблицаИсходногоНабора = СтрокиТаблицыИсходногоНабора[0];
				Если ОбщегоНазначения.КоллекцииИдентичны(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаНовогоНабора), ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаИсходногоНабора), , "Представление") Тогда
					СохранитьСтроку = Ложь;
				КонецЕсли;
				// Удалим строку из таблицы исходного набора
				ТаблицаИсходногоНабора.Удалить(СтрокаТаблицаИсходногоНабора);
			КонецЕсли; 
			
			Если СохранитьСтроку Тогда
				МассивСохраняемыхСтрок.Добавить(СтрокаТаблицаНовогоНабора);
			КонецЕсли; 
			
		КонецЦикла;
		
		Для каждого СтрокаТаблицаИсходногоНабора Из ТаблицаИсходногоНабора Цикл
			УдаляемаяЗапись = РегистрыСведений["ДокументыФизическихЛиц"].СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(УдаляемаяЗапись, СтрокаТаблицаИсходногоНабора);
			УдаляемаяЗапись.Удалить();
		КонецЦикла;
		
		Для каждого СтрокаТаблицаНовогоНабора Из МассивСохраняемыхСтрок Цикл
			НоваяЗапись = РегистрыСведений["ДокументыФизическихЛиц"].СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТаблицаНовогоНабора);
			НоваяЗапись.Записать();
		КонецЦикла;
		
	КонецЕсли; 
	
	Возврат ИзменилисьДанные;
	
КонецФункции

#КонецОбласти
