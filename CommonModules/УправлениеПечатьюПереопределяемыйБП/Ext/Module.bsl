﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииОбъектовСКомандамиПечати.
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	// БПКР
	СписокОбъектов.Добавить(Справочники.ОсновныеСредства);
	СписокОбъектов.Добавить(Справочники.Организации);
	СписокОбъектов.Добавить(Справочники.ФизическиеЛица);
	
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктСверкиВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.ПоступлениеБланковСчетовФактур);
	СписокОбъектов.Добавить(Документы.ВедомостьЗаработнойПлаты);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтПокупателя);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ГТДПоИмпорту);
	СписокОбъектов.Добавить(Документы.ДвижениеМБП);
	СписокОбъектов.Добавить(Документы.Доверенность);
	СписокОбъектов.Добавить(Документы.ДополнительныеРасходы);
	СписокОбъектов.Добавить(Документы.ЗаявлениеОВвозеТоваров);
	СписокОбъектов.Добавить(Документы.ЗемельныйНалог);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияМБП);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияТоваров);
	СписокОбъектов.Добавить(Документы.Командировка);
	СписокОбъектов.Добавить(Документы.КомплектацияНоменклатуры);
	СписокОбъектов.Добавить(Документы.Конвертация);
	СписокОбъектов.Добавить(Документы.КорректировкаДолга);
	СписокОбъектов.Добавить(Документы.НалогНаМусор);
	СписокОбъектов.Добавить(Документы.ОперацияБух);
	СписокОбъектов.Добавить(Документы.Отпуск);
	СписокОбъектов.Добавить(Документы.ОтчетПоБланкамСчетовФактур);
	СписокОбъектов.Добавить(Документы.ОтчетПоНалогуНаИмущество);
	СписокОбъектов.Добавить(Документы.ОтчетПоНДС);
	СписокОбъектов.Добавить(Документы.ОтчетПоНСП);
	СписокОбъектов.Добавить(Документы.ОтчетПоРоялти);
	СписокОбъектов.Добавить(Документы.ОтчетыПоСоциальномуФонду);
	СписокОбъектов.Добавить(Документы.ОтчетыПоПодоходномуНалогу);
	СписокОбъектов.Добавить(Документы.ОтчетПоВыплатамИУдержаниямПН);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПлатежноеПоручениеИсходящее);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.ПриемНаРаботу);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуОС);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РаботаВВыходныеИПраздничныеДни);
	СписокОбъектов.Добавить(Документы.РаботаСверхурочно);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РегламентированныйОтчет);
	СписокОбъектов.Добавить(Документы.СписаниеОС);
	СписокОбъектов.Добавить(Документы.СписаниеТоваров);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПокупателю);
	СписокОбъектов.Добавить(Документы.СчетФактураВыписанный);
	СписокОбъектов.Добавить(Документы.ТребованиеНакладная);
	СписокОбъектов.Добавить(Документы.ТрудовоеСоглашение);
	СписокОбъектов.Добавить(Документы.Увольнение);
	СписокОбъектов.Добавить(Документы.ОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы.ЕдинаяНалоговаяДекларация);
	СписокОбъектов.Добавить(Документы.ОтчетПоЕдиномуНалогу);
	СписокОбъектов.Добавить(Документы.ОтчетПоКосвеннымНалогам);
	СписокОбъектов.Добавить(Документы.УведомлениеОПолученииТоваров);
	СписокОбъектов.Добавить(Документы.ОтчетВзаимнойОТорговлеЕАЭС);
	СписокОбъектов.Добавить(Документы.КадровоеПеремещение);
	СписокОбъектов.Добавить(Документы.ОтчетПроизводстваЗаСмену);
	СписокОбъектов.Добавить(Документы.ЗакрытиеМесяца); 
	СписокОбъектов.Добавить(Документы.ТекущийРасчетНалогаНаПрибыль);
	СписокОбъектов.Добавить(Документы.ОтчетПоЗакупочнымАктам);
	
	СписокОбъектов.Добавить(ЖурналыДокументов.ЖурналОпераций);
	СписокОбъектов.Добавить(ЖурналыДокументов.ПроизводственныеДокументы);
	// Конец БПКР
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриПолученииПодписейИПечатей.
Процедура ПриПолученииПодписейИПечатей(Документы, ПодписиИПечати) Экспорт
	
	// БПКР
	ДокументыПоТипам = Новый Соответствие;
	Для Каждого Документ Из Документы Цикл
		ТипДокумента = ТипЗнч(Документ);
		Если ДокументыПоТипам[ТипДокумента] = Неопределено Тогда
			ДокументыПоТипам[ТипДокумента] = Новый Массив;
		КонецЕсли;
		ДокументыПоТипам[ТипДокумента].Добавить(Документ);
	КонецЦикла;
	
	ПустаяКартинка = Новый Картинка;
	
	КомплектыПодписейИПечатей = Новый Соответствие;
	Для Каждого ДокументыПоТипу Из ДокументыПоТипам Цикл
		ТипДокумента = ДокументыПоТипу.Ключ;
		СписокДокументов = ДокументыПоТипу.Значение;
		Если ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя")
			Или ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") 
			Или ТипДокумента = Тип("ДокументСсылка.СчетНаОплатуПокупателю") 
			Или ТипДокумента = Тип("ДокументСсылка.СчетФактураВыписанный") Тогда
			
			ОрганизацииВДокументах = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокДокументов, "Организация");
			Для Каждого ОрганизацияВДокументе Из ОрганизацииВДокументах Цикл
				Документ = ОрганизацияВДокументе.Ключ;
				Организация = ОрганизацияВДокументе.Значение;
				КомплектПодписейИПечатей = КомплектыПодписейИПечатей[Организация];
				Если КомплектПодписейИПечатей = Неопределено Тогда
					
					КомплектПодписейИПечатей = Новый Соответствие; // Ключ - имя картинки в области, Значение - картинка
					КомплектПодписейИПечатей.Вставить("ПодписьРуководителя", ПустаяКартинка);
					КомплектПодписейИПечатей.Вставить("ПодписьГлавногоБухгалтера", ПустаяКартинка);
					КомплектПодписейИПечатей.Вставить("ПечатьОрганизации", ПустаяКартинка);
					
					ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Организация, Документ.Дата);
					
					Если ЗначениеЗаполнено(ОтветственныеЛица.ФаксимилеРуководителя) Тогда 
						ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ОтветственныеЛица.ФаксимилеРуководителя);
						Если ЗначениеЗаполнено(ДвоичныеДанные) Тогда				
							КомплектПодписейИПечатей["ПодписьРуководителя"] = Новый Картинка(ДвоичныеДанные);				
						КонецЕсли;
					КонецЕсли;	
					Если ЗначениеЗаполнено(ОтветственныеЛица.ФаксимилеГлавногоБухгалтера) Тогда 
						ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ОтветственныеЛица.ФаксимилеГлавногоБухгалтера);
						Если ЗначениеЗаполнено(ДвоичныеДанные) Тогда				
							КомплектПодписейИПечатей["ПодписьГлавногоБухгалтера"] = Новый Картинка(ДвоичныеДанные);				
						КонецЕсли;
					КонецЕсли;	
					
					Если ЗначениеЗаполнено(Организация.ФайлФаксимильнаяПечать) Тогда 
						ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(Организация.ФайлФаксимильнаяПечать);
						Если ЗначениеЗаполнено(ДвоичныеДанные) Тогда				
							КомплектПодписейИПечатей["ПечатьОрганизации"] = Новый Картинка(ДвоичныеДанные);
						КонецЕсли;
					КонецЕсли;	
					
					КомплектыПодписейИПечатей.Вставить(Организация, КомплектПодписейИПечатей);
				КонецЕсли;
				ПодписиИПечати.Вставить(Документ, КомплектПодписейИПечатей);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	// Конец БПКР
	
КонецПроцедуры

#КонецОбласти
