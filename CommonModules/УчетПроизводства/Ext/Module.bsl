﻿
// УЧЕТ ПЛАНОВОЙ СТОИМОСТИ ВЫПУЩЕННОЙ ПРОДУКЦИИ

Процедура СформироватьДвиженияПлановаяСтоимостьВыпущеннойПродукции(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаПродукция = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПродукция;
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Если Не ЗначениеЗаполнено(ТаблицаПродукция)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыПлановаяСтоимостьВыпущеннойПродукции(ТаблицаПродукция, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	СпособОценкиТМЗ = БухгалтерскийУчетСервер.СпособОценкиТМЗ(Реквизиты.Период, Реквизиты.Организация);
	ВедетсяУчетПоПартиям = СпособОценкиТМЗ <> Перечисления.СпособыОценки.ПоСредней;

	Для каждого СтрокаТаблицы Из Параметры.ТаблицаПродукция Цикл

		Проводка = Движения.Хозрасчетный.Добавить();
		Проводка.Период = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание = СтрокаТаблицы.Содержание;

		Проводка.СчетДт = СтрокаТаблицы.СчетУчета;
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Номенклатура", СтрокаТаблицы.Номенклатура);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Склады", СтрокаТаблицы.Склад);
		Если ВедетсяУчетПоПартиям Тогда
			БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Партии", Реквизиты.Регистратор);
		КонецЕсли;
	
		СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
		
		Если СвойстваСчетаДт.Количественный Тогда
			Проводка.КоличествоДт = СтрокаТаблицы.Количество;
		КонецЕсли;

		Проводка.СчетКт = СтрокаТаблицы.СчетЗатрат;
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппаЗатрат);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Подразделения", СтрокаТаблицы.ПодразделениеЗатрат);

		Проводка.Сумма = СтрокаТаблицы.СуммаПлановая;

	КонецЦикла;

	Движения.Хозрасчетный.Записывать = Истина;

КонецПроцедуры

Функция ПодготовитьПараметрыПлановаяСтоимостьВыпущеннойПродукции(ТаблицаПродукция, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы Параметры.ТаблицаПродукция

	СписокОбязательныхКолонок = ""
	+ "Номенклатура,"               // <СправочникСсылка.Номенклатура> - номенклатура выпущенной продукции
	+ "СчетЗатрат,"                 // <ПланСчетовСсылка.Хозрасчетный> - счет учета затрат на выпуск продукции
	+ "ПодразделениеЗатрат,"        // <Ссылка на справочник подразделений> - подразделение, выпустившее продукцию
	+ "НоменклатурнаяГруппаЗатрат," // <СправочникСсылка.НомеклатурныеГруппы> - номеклатурная группа выпущенной продукции
	+ "СчетУчета,"                  // <ПланСчетовСсылка.Хозрасчетный> - счет учета, на которой поступает продукция
	+ "Склад,"                      // <СправочникСсылка.Склады> - склад, на который поступает продукция
	+ "Количество,"                 // <Число,15,3> - количество выпущенной продукции
	+ "СуммаПлановая,"              // <Число,15,2> - плановая стоимость выпущенной продукции
	+ "Содержание";                 // <Строка,150> - содержание проводки

	Параметры.Вставить("ТаблицаПродукция", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаПродукция, СписокОбязательныхКолонок));

	// Подготовка таблицы Параметры.Реквизиты

	СписокОбязательныхКолонок = ""
	+ "Регистратор,"                // <ДокументСсылка.*> - документ-регистратор движений
	+ "Период,"                     // <Дата> - период движений - дата документа
	+ "Организация";                // <СправочникСсылка.Организации>

	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

// УЧЕТ ПЛАНОВОЙ СТОИМОСТИ ВЫПУЩЕННЫХ УСЛУГ

Процедура СформироватьДвиженияПлановаяСтоимостьВыпущенныхУслуг(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаУслуги = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаУслуги;
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Если Не ЗначениеЗаполнено(ТаблицаУслуги)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыПлановаяСтоимостьВыпущенныхУслуг(ТаблицаУслуги, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаУслуги Цикл
	
		Проводка = Движения.Хозрасчетный.Добавить();
		
		Проводка.Период = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание = СтрокаТаблицы.Содержание;

		Проводка.СчетДт	= СтрокаТаблицы.СчетСписания;
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, СтрокаТаблицы.ВидСубконтоСписания1, СтрокаТаблицы.СубконтоСписания1);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, СтрокаТаблицы.ВидСубконтоСписания2, СтрокаТаблицы.СубконтоСписания2);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, СтрокаТаблицы.ВидСубконтоСписания3, СтрокаТаблицы.СубконтоСписания3);
	
		Проводка.СчетКт = СтрокаТаблицы.СчетЗатрат;
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппаЗатрат);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Подразделения", СтрокаТаблицы.ПодразделениеЗатрат);

		Проводка.Сумма = СтрокаТаблицы.СуммаПлановая;
	КонецЦикла;

	Движения.Хозрасчетный.Записывать = Истина;

КонецПроцедуры

Функция ПодготовитьПараметрыПлановаяСтоимостьВыпущенныхУслуг(ТаблицаУслуги, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы Параметры.ТаблицаУслуги

	СписокОбязательныхКолонок = ""
	+ "Номенклатура,"               // <СправочникСсылка.Номенклатура> - номенклатура оказанных услуг
	+ "СчетЗатрат,"                 // <ПланСчетовСсылка.Хозрасчетный> - счет учета затрат на выпуск услуг
	+ "ПодразделениеЗатрат,"        // <Ссылка на справочник подразделений> - производственное подразделение, оказавшее услуги
	+ "НоменклатурнаяГруппаЗатрат," // <СправочникСсылка.НомеклатурныеГруппы> - номеклатурная группа оказанных услуг
	+ "СчетСписания,"               // <ПланСчетовСсылка.Хозрасчетный> - счет списания плановой стоимости услуг
	+ "ВидСубконтоСписания1,"       // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> - вид субконто счета списания
	+ "ВидСубконтоСписания2,"       // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> - вид субконто счета списания
	+ "ВидСубконтоСписания3,"       // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> - вид субконто счета списания
	+ "СубконтоСписания1,"          // - значение субконто счета списания
	+ "СубконтоСписания2,"          // - значение субконто счета списания
	+ "СубконтоСписания3,"          // - значение субконто счета списания
	+ "Количество,"                 // <Число,15,3> - объем оказанных услуг, выраженный в количественном показателе
	+ "СуммаПлановая,"              // <Число,15,2> - плановая стоимость оказанных услуг
	+ "Содержание";                 // <Строка,150> - содержание проводки

	Параметры.Вставить("ТаблицаУслуги", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаУслуги, СписокОбязательныхКолонок));

	// Подготовка таблицы Параметры.Реквизиты

	СписокОбязательныхКолонок = ""
	+ "Период,"                     // <Дата> - период движений - дата документа
	+ "Организация";                // <СправочникСсылка.Организации>

	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

// УЧЕТ ПЛАНОВОЙ СТОИМОСТИ ВЫПУЩЕННЫХ УСЛУГ ПО ПЕРЕРАБОТКЕ

Процедура СформироватьДвиженияПлановаяСтоимостьУслугПоПереработке(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаУслуги = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаУслуги;
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Если Не ЗначениеЗаполнено(ТаблицаУслуги) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыПлановаяСтоимостьУслугПоПереработке(ТаблицаУслуги, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаУслуги Цикл
	
		Проводка = Движения.Хозрасчетный.Добавить();
		
		Проводка.Период      = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание  = СтрокаТаблицы.Содержание;
		Проводка.Сумма       = СтрокаТаблицы.Сумма;
		
		// Дт
		
		Проводка.СчетДт	= СтрокаТаблицы.СчетРасходов;
		
		БухгалтерскийУчетСервер.УстановитьСубконто(
			Проводка.СчетДт, 
			Проводка.СубконтоДт, 
			ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы, 
			СтрокаТаблицы.НоменклатурнаяГруппа);
			
		//БухгалтерскийУчетСервер.УстановитьСубконто(
		//	Проводка.СчетДт, 
		//	Проводка.СубконтоДт, 
		//	ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы, 
		//	СтрокаТаблицы.ВидДеятельности);
		//	
		//БухгалтерскийУчетСервер.УстановитьСубконто(
		//	Проводка.СчетДт, 
		//	Проводка.СубконтоДт, 
		//	ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РеализуемыеАктивы, 
		//	СтрокаТаблицы.Номенклатура);
	
		СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетДт);
		
		Если СвойстваСчетаДт.Количественный Тогда
			Проводка.КоличествоДт = СтрокаТаблицы.Количество;
		КонецЕсли;

		// Кт
		
		Проводка.СчетКт = СтрокаТаблицы.СчетЗатрат;
		
		БухгалтерскийУчетСервер.УстановитьСубконто(
			Проводка.СчетКт, 
			Проводка.СубконтоКт, 
			ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура,
			СтрокаТаблицы.НоменклатураЗатрат);

		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
		
		Если СвойстваСчетаКт.Количественный Тогда
			Проводка.КоличествоКт = СтрокаТаблицы.Количество;
		КонецЕсли;
		
	КонецЦикла;

	Движения.Хозрасчетный.Записывать = Истина;

КонецПроцедуры

Функция ПодготовитьПараметрыПлановаяСтоимостьУслугПоПереработке(ТаблицаУслуги, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы Параметры.ТаблицаУслуги

	СписокОбязательныхКолонок = ""
	+ "Номенклатура,"               // <СправочникСсылка.Номенклатура> - номенклатура оказанных услуг
	
	+ "СчетЗатрат,"                 // <ПланСчетовСсылка.Хозрасчетный> - счет учета затрат на выпуск услуг
	+ "НоменклатураЗатрат,"         // <СправочникСсылка.Номенклатура> - номенклатура, в разрезе которой учитываются затраты на оказание услуг
	
	+ "СчетРасходов,"               // <ПланСчетовСсылка.Хозрасчетный> - счет учета расходов
	+ "НоменклатурнаяГруппа,"       // <Характеристика.ВидыСубконтоХозрасчетные> - субконто НоменклатурнаяГруппа
	
	+ "Количество,"                 // <Число,15,3> - объем оказанных услуг в количественном выражении
	+ "Сумма,"                      // <Число,15,2> - плановая стоимость оказанных услуг
	+ "Содержание";                 // <Строка,150> - содержание проводки

	Параметры.Вставить("ТаблицаУслуги", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаУслуги, СписокОбязательныхКолонок));

	// Подготовка таблицы Параметры.Реквизиты

	СписокОбязательныхКолонок = ""
	+ "Период,"                     // <Дата> - период движений - дата документа
	+ "Организация";                // <СправочникСсылка.Организации>

	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

// ВЫПУСК ПРОДУКЦИИ, УСЛУГ

Процедура СформироватьДвиженияВыпускПродукции(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаВыпуск = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВыпуск;
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Если Не ЗначениеЗаполнено(ТаблицаВыпуск)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыВыпускПродукцииУслуг(ТаблицаВыпуск, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаВыпуск Цикл

		// Отражение выпуска в регистре накопления ВыпускПродукцииУслуг
		Движение = Движения.ВыпускПродукцииУслуг.Добавить();

		Движение.Период = Реквизиты.Период;
		Движение.Организация = Реквизиты.Организация;
		Движение.Продукция = СтрокаТаблицы.Номенклатура;
		
		Движение.СчетЗатрат            = СтрокаТаблицы.СчетЗатрат;
		Движение.Подразделение         = СтрокаТаблицы.ПодразделениеЗатрат;
		Движение.НоменклатурнаяГруппа  = СтрокаТаблицы.НоменклатурнаяГруппаЗатрат;
		
		Движение.СчетСписания          = СтрокаТаблицы.СчетСписания;
		//Движение.ПодразделениеСписания = СтрокаТаблицы.ПодразделениеСписания;

		СвойстваСчетаСписания = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Движение.СчетСписания);
		Если СвойстваСчетаСписания.КоличествоСубконто > 0 Тогда
			Движение.СубконтоСписания1 = СтрокаТаблицы.СубконтоСписания1;
		КонецЕсли;
		Если СвойстваСчетаСписания.КоличествоСубконто > 1 Тогда
			Движение.СубконтоСписания2 = СтрокаТаблицы.СубконтоСписания2;
		КонецЕсли;
		Если СвойстваСчетаСписания.КоличествоСубконто > 2 Тогда
			Движение.СубконтоСписания3 = СтрокаТаблицы.СубконтоСписания3;
		КонецЕсли;

		Движение.ПрямыеРасходыРаспределятьПоКоличеству = СтрокаТаблицы.ПрямыеРасходыРаспределятьПоКоличеству;
		Движение.Количество        = СтрокаТаблицы.Количество;
		Движение.ПлановаяСтоимость = СтрокаТаблицы.ПлановаяСтоимость;

	КонецЦикла;

	Движения.ВыпускПродукцииУслуг.Записывать = Истина;

КонецПроцедуры

Процедура СформироватьДвиженияВыпускУслуг(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаВыпуск = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВыпуск;
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Если Не ЗначениеЗаполнено(ТаблицаВыпуск)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыВыпускПродукцииУслуг(ТаблицаВыпуск, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаВыпуск Цикл

		// Отражение выпуска в регистре накопления ВыпускПродукцииУслуг
		Движение = Движения.ВыпускПродукцииУслуг.Добавить();

		Движение.Период = Реквизиты.Период;
		Движение.Организация = Реквизиты.Организация;
		Движение.Продукция = СтрокаТаблицы.Номенклатура;
		
		Движение.СчетЗатрат            = СтрокаТаблицы.СчетЗатрат;
		Движение.Подразделение         = СтрокаТаблицы.ПодразделениеЗатрат;
		Движение.НоменклатурнаяГруппа  = СтрокаТаблицы.НоменклатурнаяГруппаЗатрат;
		
		Движение.СчетСписания          = СтрокаТаблицы.СчетСписания;
		//Движение.ПодразделениеСписания = СтрокаТаблицы.ПодразделениеСписания;

		СвойстваСчетаСписания = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Движение.СчетСписания);
		Если СвойстваСчетаСписания.КоличествоСубконто > 0 Тогда
			Движение.СубконтоСписания1 = СтрокаТаблицы.СубконтоСписания1;
		КонецЕсли;
		Если СвойстваСчетаСписания.КоличествоСубконто > 1 Тогда
			Движение.СубконтоСписания2 = СтрокаТаблицы.СубконтоСписания2;
		КонецЕсли;
		Если СвойстваСчетаСписания.КоличествоСубконто > 2 Тогда
			Движение.СубконтоСписания3 = СтрокаТаблицы.СубконтоСписания3;
		КонецЕсли;

		Движение.ПрямыеРасходыРаспределятьПоКоличеству = СтрокаТаблицы.ПрямыеРасходыРаспределятьПоКоличеству;
		Движение.Количество        = СтрокаТаблицы.Количество;
		Движение.ПлановаяСтоимость = СтрокаТаблицы.ПлановаяСтоимость;

	КонецЦикла;

	Движения.ВыпускПродукцииУслуг.Записывать = Истина;

КонецПроцедуры

Функция ПодготовитьПараметрыВыпускПродукцииУслуг(ТаблицаВыпуск, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы Параметры.ТаблицаВыпуск

	СписокОбязательныхКолонок = ""
	+ "Номенклатура,"                          // <СправочникСсылка.Номенклатура> - номенклатура выпущенной продукции, услуг
	+ "СчетЗатрат,"                            // <ПланСчетовСсылка.Хозрасчетный> - счет учета затрат на выпуск продукции, услуг
	+ "ПодразделениеЗатрат,"                   // <Ссылка на справочник подразделений> - производственное подразделение, выпустившее продукцию, услуги
	+ "НоменклатурнаяГруппаЗатрат,"            // <СправочникСсылка.НомеклатурныеГруппы> - номеклатурная группа выпущенной продукции, услуг
	+ "СчетСписания,"                          // <ПланСчетовСсылка.Хозрасчетный> - счет списания плановой стоимости продукции, услуг
	+ "СубконтоСписания1,"                     // - значение субконто счета списания
	+ "СубконтоСписания2,"                     // - значение субконто счета списания
	+ "СубконтоСписания3,"                     // - значение субконто счета списания
	+ "Количество,"                            // <Число,15,3> - количество выпущенной продукции, услуг
	+ "ПлановаяСтоимость,"                     // <Число,15,2> - плановая стоимость выпущенной продукции, услуг
	+ "ПрямыеРасходыРаспределятьПоКоличеству"; // <Булево> - услуги выражаются в количественных показателях
	Параметры.Вставить("ТаблицаВыпуск", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаВыпуск, СписокОбязательныхКолонок));

	// Подготовка таблицы Параметры.Реквизиты

	СписокОбязательныхКолонок = ""
	+ "Период,"                                // <Дата> - период движений - дата документа
	+ "Организация";                           // <СправочникСсылка.Организации>
	
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

// ВЫПУСК ВОЗВРАТНЫХ ОТХОДОВ

Процедура СформироватьДвиженияВыпускОтходов(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаОтходы = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОтходы;
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Если Не ЗначениеЗаполнено(ТаблицаОтходы)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыВыпускОтходов(ТаблицаОтходы, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	СпособОценкиТМЗ = БухгалтерскийУчетСервер.СпособОценкиТМЗ(Реквизиты.Период, Реквизиты.Организация);
	ВедетсяУчетПоПартиям = СпособОценкиТМЗ <> Перечисления.СпособыОценки.ПоСредней;
	
	Для Каждого СтрокаТаблицы Из Параметры.ТаблицаОтходы Цикл
		
		Проводка = Движения.Хозрасчетный.Добавить();
		
		Проводка.Период = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание = Реквизиты.Содержание;
		
		Проводка.СчетКт = СтрокаТаблицы.СчетУчета;
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Номенклатура", СтрокаТаблицы.Номенклатура);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Склады", СтрокаТаблицы.Склад);
		Если ВедетсяУчетПоПартиям Тогда
			БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Партии", Реквизиты.Регистратор);
		КонецЕсли;
		
		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);
		
		Если СвойстваСчетаКт.Количественный Тогда
			Проводка.КоличествоКт = - СтрокаТаблицы.Количество;
		КонецЕсли;
		
		Проводка.СчетДт = СтрокаТаблицы.СчетЗатрат;
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.НоменклатурнаяГруппаЗатрат);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Подразделения", СтрокаТаблицы.ПодразделениеЗатрат);
		БухгалтерскийУчетСервер.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "СтатьиЗатрат", СтрокаТаблицы.СтатьяЗатрат);
			
		Проводка.Сумма = - СтрокаТаблицы.Сумма;
		
	КонецЦикла;
	
	Движения.Хозрасчетный.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыВыпускОтходов(ТаблицаОтходы, ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы Параметры.ТаблицаОтходы

	СписокОбязательныхКолонок = ""
	+ "Номенклатура,"               // <СправочникСсылка.Номенклатура> - номенклатура выпущенных возвратных отходов
	+ "СчетЗатрат,"                 // <ПланСчетовСсылка.Хозрасчетный> - счет учета затрат на выпуск продукции
	+ "ПодразделениеЗатрат,"        // <Ссылка на справочник подразделений> - производственное подразделение, выпустившее продукцию, услуги
	+ "НоменклатурнаяГруппаЗатрат," // <СправочникСсылка.НомеклатурныеГруппы> - номеклатурная группа выпущенной продукции
	+ "Продукция,"                  // <СправочникСсылка.Номенклатура> - выпущенная продукция
	+ "СтатьяЗатрат,"               // <СправочникСсылка.СтатьяЗатрат> - статья учета затрат на выпуск продукции
	+ "СчетУчета,"                  // <ПланСчетовСсылка.Хозрасчетный> - счет учета возвратных отходов
	+ "Склад,"                      // <СправочникСсылка.Склады> - склад, на который поступают отходы
	+ "Количество,"                 // <Число,15,3> - количество выпущенных возвратных отходов
	+ "Сумма";                      // <Число,15,2> - себестоимость выпущенных возвратных отходов

	Параметры.Вставить("ТаблицаОтходы", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаОтходы, СписокОбязательныхКолонок));

	// Подготовка таблицы Параметры.Реквизиты

	СписокОбязательныхКолонок = ""
	+ "Регистратор,"                // <ДокументСсылка.*> - документ-регистратор движений
	+ "Период,"                     // <Дата> - период движений - дата документа
	+ "Организация,"                // <СправочникСсылка.Организации>
	+ "Содержание";                 // <Строка,150> - содержание проводки

	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

// СЧЕТА УЧЕТА В ДОКУМЕНТАХ

Процедура ОграничитьВыборСчетамиПрямыхРасходов(ЭлементФормы) Экспорт
	
	Правила    = ПредопределенныеСчетаПрямыхРасходов();
	Исключения = Новый Массив;
	Исключения.Добавить(ПланыСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья); // Фактически, это счет запасов, а не расходов
	
	УсловияОтбора = БухгалтерскийУчетСервер.НовыеУсловияОтбораСубсчетов();
	УсловияОтбора.ИспользоватьВПроводках = Истина; // Исключить запрещенные для использования в проводках
	УсловияОтбора.Валютный               = Неопределено; // Не важно, валютные или нет
	УсловияОтбора.Забалансовый           = Ложь;   // Исключить забалансовые
	УсловияОтбора.СчетаИсключения        = Исключения;
	
	СчетаДляОтбора = БухгалтерскийУчетСервер.СформироватьМассивСубсчетовПоОтбору(Правила, УсловияОтбора);
		
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(ЭлементФормы, СчетаДляОтбора);
	
КонецПроцедуры

// Возвращает предопределенные счета учета расходов основного и вспомогательного производства
//
// Возвращаемое значение:
//  Массив значений типа ПланСчетовСсылка.Хозрасчетный
//
Функция ПредопределенныеСчетаПрямыхРасходов() Экспорт
	
	СчетаРасходов = Новый Массив();
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОсновноеПроизводство); // есть исключения
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ВспомогательноеПроизводство);
	
	Возврат СчетаРасходов;
	
КонецФункции

// СПИСКИ СЧЕТОВ УЧЕТА ЗАТРАТ

// Возвращает предопределенные счета учета общепроизводственных и общехозяйственных расходов
//
// Возвращаемое значение:
//  Массив значений типа ПланСчетовСсылка.Хозрасчетный
//
Функция ПредопределенныеСчетаКосвенныхРасходов() Экспорт
	
	СчетаРасходов = Новый Массив();
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ПроизводственныеРасходы);
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОбщиеИАдминистративныеРасходы);
	
	Возврат СчетаРасходов;

КонецФункции
